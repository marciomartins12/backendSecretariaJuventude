import prisma from '../utils/database';
import { AttendanceStatus } from '../types';

export class AttendanceService {
  
  /**
   * Gera registros de falta para funcionários que deveriam trabalhar mas não bateram ponto
   */
  static async generateAbsenceRecords(date: Date): Promise<void> {
    try {
      const dateStr = date.toISOString().split('T')[0];
      const dayName = date.toLocaleDateString('en-US', { weekday: 'long' }).toLowerCase();
      
      const dayMapping: { [key: string]: string } = {
        'sunday': 'sunday',
        'monday': 'monday', 
        'tuesday': 'tuesday',
        'wednesday': 'wednesday',
        'thursday': 'thursday',
        'friday': 'friday',
        'saturday': 'saturday'
      };
      
      const dayOfWeek = dayMapping[dayName] || dayName;

      // Buscar todos os funcionários que deveriam trabalhar neste dia
      const employees = await prisma.employee.findMany();
      
      const scheduledEmployees = employees.filter(employee => {
        const workDays = JSON.parse(employee.workDays);
        return workDays.includes(dayOfWeek);
      });

      // Verificar quais não têm registro de ponto
      for (const employee of scheduledEmployees) {
        const existingRecord = await prisma.timeRecord.findUnique({
          where: {
            employeeId_date: {
              employeeId: employee.id,
              date: new Date(dateStr)
            }
          }
        });

        if (!existingRecord) {
          // Criar registro de falta
          await prisma.timeRecord.create({
            data: {
              employeeId: employee.id,
              date: new Date(dateStr),
              status: AttendanceStatus.ABSENT,
              observations: 'Falta detectada automaticamente - funcionário não bateu ponto'
            }
          });
        }
      }
    } catch (error) {
      console.error('Erro ao gerar registros de falta:', error);
    }
  }

  /**
   * Detecta o status de presença baseado nos horários
   * REGRA SIMPLES: Se tem entrada = PRESENTE, se não tem = AUSENTE
   */
  static detectAttendanceStatus(entryTime?: string): AttendanceStatus {
    return entryTime ? AttendanceStatus.PRESENT : AttendanceStatus.ABSENT;
  }

  /**
   * Converte hora HH:MM para minutos
   */
  private static timeToMinutes(time: string): number {
    const [hours, minutes] = time.split(':').map(Number);
    return hours * 60 + minutes;
  }

  /**
   * Gera relatório completo de frequência
   */
  static async getAttendanceReport(startDate: string, endDate: string, employeeId?: string) {
    const where: any = {
      date: {
        gte: new Date(startDate),
        lte: new Date(endDate)
      }
    };

    if (employeeId) {
      where.employeeId = employeeId;
    }

    const records = await prisma.timeRecord.findMany({
      where,
      include: {
        employee: true
      },
      orderBy: [
        { date: 'desc' },
        { employee: { name: 'asc' } }
      ]
    });

    // Agrupar por funcionário e calcular estatísticas
    const reportByEmployee: { [key: string]: any } = {};

    records.forEach(record => {
      const employeeKey = record.employee.id;
      
      if (!reportByEmployee[employeeKey]) {
        reportByEmployee[employeeKey] = {
          employee: {
            ...record.employee,
            workDays: JSON.parse(record.employee.workDays)
          },
          totalDays: 0,
          present: 0,
          absent: 0,
          records: []
        };
      }

      const stats = reportByEmployee[employeeKey];
      stats.totalDays++;
      stats.records.push({
        ...record,
        date: record.date.toISOString().split('T')[0]
      });

      // Contar por status (apenas PRESENT/ABSENT)
      if (record.status === AttendanceStatus.PRESENT) {
        stats.present++;
      } else {
        stats.absent++;
      }
    });

    return Object.values(reportByEmployee);
  }
}
