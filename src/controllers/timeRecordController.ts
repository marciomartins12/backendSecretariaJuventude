import { Request, Response } from 'express';
import { z } from 'zod';
import prisma from '../utils/database';
import { CreateTimeRecordRequest, AttendanceStatus } from '../types';
import { AttendanceService } from '../services/attendanceService';

const createTimeRecordSchema = z.object({
  employeeId: z.string().min(1, 'ID do funcionário é obrigatório'),
  date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Data deve estar no formato YYYY-MM-DD'),
  entryTime: z.string().regex(/^\d{2}:\d{2}$/, 'Hora de entrada deve estar no formato HH:MM').optional(),
  exitTime: z.string().regex(/^\d{2}:\d{2}$/, 'Hora de saída deve estar no formato HH:MM').optional(),
  status: z.enum(['PRESENT', 'ABSENT']).optional(),
  shift: z.enum(['MORNING', 'AFTERNOON', 'FULL_DAY']).optional(),
  observations: z.string().optional()
});

export const getTimeRecords = async (req: Request, res: Response): Promise<void> => {
  try {
    const { employeeId, startDate, endDate } = req.query;

    const where: any = {};

    if (employeeId) {
      where.employeeId = employeeId as string;
    }

    if (startDate || endDate) {
      where.date = {};
      if (startDate) {
        where.date.gte = new Date(startDate as string);
      }
      if (endDate) {
        where.date.lte = new Date(endDate as string);
      }
    }

    const timeRecords = await prisma.timeRecord.findMany({
      where,
      include: {
        employee: true
      },
      orderBy: [
        { date: 'desc' },
        { createdAt: 'desc' }
      ]
    });

    const formattedRecords = timeRecords.map(record => ({
      id: record.id,
      employeeId: record.employeeId,
      date: record.date.toISOString().split('T')[0],
      entryTime: record.entryTime,
      exitTime: record.exitTime,
      status: record.status,
      shift: record.shift,
      observations: record.observations,
      status: record.status,
      shift: record.shift,
      observations: record.observations,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
      employee: {
        ...record.employee,
        workDays: JSON.parse(record.employee.workDays)
      }
    }));

    res.json(formattedRecords);
  } catch (error) {
    console.error('Erro ao buscar registros de ponto:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
};

export const getTodayRecords = async (req: Request, res: Response): Promise<void> => {
  try {
    const today = new Date();
    const todayStr = today.toISOString().split('T')[0];

    const timeRecords = await prisma.timeRecord.findMany({
      where: {
        date: new Date(todayStr)
      },
      include: {
        employee: true
      },
      orderBy: { createdAt: 'desc' }
    });

    const formattedRecords = timeRecords.map(record => ({
      id: record.id,
      employeeId: record.employeeId,
      date: record.date.toISOString().split('T')[0],
      entryTime: record.entryTime,
      exitTime: record.exitTime,
      status: record.status,
      shift: record.shift,
      observations: record.observations,
      status: record.status,
      shift: record.shift,
      observations: record.observations,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
      employee: {
        ...record.employee,
        workDays: JSON.parse(record.employee.workDays)
      }
    }));

    res.json(formattedRecords);
  } catch (error) {
    console.error('Erro ao buscar registros de hoje:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
};

export const createTimeRecord = async (req: Request, res: Response): Promise<void> => {
  try {
    const data: CreateTimeRecordRequest = createTimeRecordSchema.parse(req.body);

    // Verificar se o funcionário existe
    const employee = await prisma.employee.findUnique({
      where: { id: data.employeeId }
    });

    if (!employee) {
      res.status(404).json({ error: 'Funcionário não encontrado' });
      return;
    }

    // Verificar se o funcionário está escalado para o dia
    const date = new Date(data.date);
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
    const workDays = JSON.parse(employee.workDays);
    
    if (!workDays.includes(dayOfWeek)) {
      res.status(400).json({ error: 'Funcionário não está escalado para este dia' });
      return;
    }

    // Verificar se já existe registro para este dia
    const existingRecord = await prisma.timeRecord.findUnique({
      where: {
        employeeId_date: {
          employeeId: data.employeeId,
          date: new Date(data.date)
        }
      }
    });

    if (existingRecord) {
      // Atualizar registro existente
      let updateData: any = {};

      if (data.entryTime && !existingRecord.entryTime) {
        updateData.entryTime = data.entryTime;
      } else if (data.exitTime && existingRecord.entryTime && !existingRecord.exitTime) {
        updateData.exitTime = data.exitTime;
      } else {
        res.status(400).json({ 
          error: 'Não é possível registrar. Verifique se já não foi registrada entrada e saída para este dia.' 
        });
        return;
      }

      const updatedRecord = await prisma.timeRecord.update({
        where: { id: existingRecord.id },
        data: updateData,
        include: { employee: true }
      });

      const formattedRecord = {
        id: updatedRecord.id,
        employeeId: updatedRecord.employeeId,
        date: updatedRecord.date.toISOString().split('T')[0],
        entryTime: updatedRecord.entryTime,
        exitTime: updatedRecord.exitTime,
        status: updatedRecord.status,
        shift: updatedRecord.shift,
        observations: updatedRecord.observations,
        createdAt: updatedRecord.createdAt,
        updatedAt: updatedRecord.updatedAt,
        employee: {
          ...updatedRecord.employee,
          workDays: JSON.parse(updatedRecord.employee.workDays)
        }
      };

      res.json(formattedRecord);
    } else {
      // Criar novo registro
      if (!data.entryTime && !data.exitTime) {
        res.status(400).json({ error: 'Deve fornecer pelo menos horário de entrada ou saída' });
        return;
      }

      if (data.exitTime && !data.entryTime) {
        res.status(400).json({ error: 'Não é possível registrar saída sem entrada' });
        return;
      }

      const newRecord = await prisma.timeRecord.create({
        data: {
          employeeId: data.employeeId,
          date: new Date(data.date),
          entryTime: data.entryTime,
          exitTime: data.exitTime
        },
        include: { employee: true }
      });

      const formattedRecord = {
        id: newRecord.id,
        employeeId: newRecord.employeeId,
        date: newRecord.date.toISOString().split('T')[0],
        entryTime: newRecord.entryTime,
        exitTime: newRecord.exitTime,
        status: newRecord.status,
        shift: newRecord.shift,
        observations: newRecord.observations,
        createdAt: newRecord.createdAt,
        updatedAt: newRecord.updatedAt,
        employee: {
          ...newRecord.employee,
          workDays: JSON.parse(newRecord.employee.workDays)
        }
      };

      res.status(201).json(formattedRecord);
    }
  } catch (error) {
    if (error instanceof z.ZodError) {
      res.status(400).json({ error: error.errors[0].message });
      return;
    }

    console.error('Erro ao criar/atualizar registro de ponto:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
};

export const deleteTimeRecord = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;

    const existingRecord = await prisma.timeRecord.findUnique({
      where: { id }
    });

    if (!existingRecord) {
      res.status(404).json({ error: 'Registro de ponto não encontrado' });
      return;
    }

    await prisma.timeRecord.delete({
      where: { id }
    });

    res.status(204).send();
  } catch (error) {
    console.error('Erro ao deletar registro de ponto:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
};

// Endpoint especial para registrar ponto (entrada ou saída automática)
export const clockInOut = async (req: Request, res: Response): Promise<void> => {
  try {
    const { employeeId } = req.body;

    if (!employeeId) {
      res.status(400).json({ error: 'ID do funcionário é obrigatório' });
      return;
    }

    // Verificar se o funcionário existe
    const employee = await prisma.employee.findUnique({
      where: { id: employeeId }
    });

    if (!employee) {
      res.status(404).json({ error: 'Funcionário não encontrado' });
      return;
    }

    const today = new Date();
    const todayStr = today.toISOString().split('T')[0];
    const currentTime = today.toTimeString().slice(0, 5); // HH:MM

    // Verificar se o funcionário está escalado para hoje
    const dayName = today.toLocaleDateString('en-US', { weekday: 'long' }).toLowerCase();
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
    const workDays = JSON.parse(employee.workDays);
    
    if (!workDays.includes(dayOfWeek)) {
      res.status(400).json({ error: 'Funcionário não está escalado para hoje' });
      return;
    }

    // Verificar se já existe registro para hoje
    const existingRecord = await prisma.timeRecord.findUnique({
      where: {
        employeeId_date: {
          employeeId,
          date: new Date(todayStr)
        }
      }
    });

    if (existingRecord) {
      if (!existingRecord.entryTime) {
        // Registrar entrada
        const updatedRecord = await prisma.timeRecord.update({
          where: { id: existingRecord.id },
          data: { entryTime: currentTime },
          include: { employee: true }
        });

        const formattedRecord = {
          id: updatedRecord.id,
          employeeId: updatedRecord.employeeId,
          date: updatedRecord.date.toISOString().split('T')[0],
          entryTime: updatedRecord.entryTime,
          exitTime: updatedRecord.exitTime,
        status: updatedRecord.status,
        shift: updatedRecord.shift,
        observations: updatedRecord.observations,
          createdAt: updatedRecord.createdAt,
          updatedAt: updatedRecord.updatedAt,
          employee: {
            ...updatedRecord.employee,
            workDays: JSON.parse(updatedRecord.employee.workDays)
          }
        };

        res.json({ 
          message: 'Entrada registrada com sucesso',
          record: formattedRecord,
          action: 'entry'
        });
      } else if (!existingRecord.exitTime) {
        // Registrar saída
        const updatedRecord = await prisma.timeRecord.update({
          where: { id: existingRecord.id },
          data: { exitTime: currentTime },
          include: { employee: true }
        });

        const formattedRecord = {
          id: updatedRecord.id,
          employeeId: updatedRecord.employeeId,
          date: updatedRecord.date.toISOString().split('T')[0],
          entryTime: updatedRecord.entryTime,
          exitTime: updatedRecord.exitTime,
        status: updatedRecord.status,
        shift: updatedRecord.shift,
        observations: updatedRecord.observations,
          createdAt: updatedRecord.createdAt,
          updatedAt: updatedRecord.updatedAt,
          employee: {
            ...updatedRecord.employee,
            workDays: JSON.parse(updatedRecord.employee.workDays)
          }
        };

        res.json({ 
          message: 'Saída registrada com sucesso',
          record: formattedRecord,
          action: 'exit'
        });
      } else {
        res.status(400).json({ error: 'Entrada e saída já foram registradas para hoje' });
      }
    } else {
      // Criar novo registro com entrada
      const newRecord = await prisma.timeRecord.create({
        data: {
          employeeId,
          date: new Date(todayStr),
          entryTime: currentTime
        },
        include: { employee: true }
      });

      const formattedRecord = {
        id: newRecord.id,
        employeeId: newRecord.employeeId,
        date: newRecord.date.toISOString().split('T')[0],
        entryTime: newRecord.entryTime,
        exitTime: newRecord.exitTime,
        status: newRecord.status,
        shift: newRecord.shift,
        observations: newRecord.observations,
        createdAt: newRecord.createdAt,
        updatedAt: newRecord.updatedAt,
        employee: {
          ...newRecord.employee,
          workDays: JSON.parse(newRecord.employee.workDays)
        }
      };

      res.status(201).json({ 
        message: 'Entrada registrada com sucesso',
        record: formattedRecord,
        action: 'entry'
      });
    }
  } catch (error) {
    console.error('Erro ao registrar ponto:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
};

// Gerar relatório completo de frequência (incluindo faltas)
export const getAttendanceReport = async (req: Request, res: Response): Promise<void> => {
  try {
    const { startDate, endDate, employeeId } = req.query;

    if (!startDate || !endDate) {
      res.status(400).json({ error: 'Data inicial e final são obrigatórias' });
      return;
    }

    const report = await AttendanceService.getAttendanceReport(
      startDate as string, 
      endDate as string, 
      employeeId as string
    );

    res.json(report);
  } catch (error) {
    console.error('Erro ao gerar relatório de frequência:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
};

// Detectar e criar registros de falta para um período
export const generateAbsenceRecords = async (req: Request, res: Response): Promise<void> => {
  try {
    const { date } = req.body;

    if (!date) {
      res.status(400).json({ error: 'Data é obrigatória' });
      return;
    }

    await AttendanceService.generateAbsenceRecords(new Date(date));

    res.json({ message: 'Registros de falta gerados com sucesso' });
  } catch (error) {
    console.error('Erro ao gerar registros de falta:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
};

// Marcar falta manualmente
export const markAbsence = async (req: Request, res: Response): Promise<void> => {
  try {
    const { employeeId, date, status, observations, shift } = req.body;

    if (!employeeId || !date || !status) {
      res.status(400).json({ error: 'Funcionário, data e status são obrigatórios' });
      return;
    }

    // Verificar se o funcionário existe
    const employee = await prisma.employee.findUnique({
      where: { id: employeeId }
    });

    if (!employee) {
      res.status(404).json({ error: 'Funcionário não encontrado' });
      return;
    }

    // Criar ou atualizar registro
    const record = await prisma.timeRecord.upsert({
      where: {
        employeeId_date: {
          employeeId,
          date: new Date(date)
        }
      },
      update: {
        status,
        observations,
        ...(shift && { shift })
      },
      create: {
        employeeId,
        date: new Date(date),
        status,
        observations,
        shift: shift || 'FULL_DAY'
      },
      include: { employee: true }
    });

    const formattedRecord = {
      id: record.id,
      employeeId: record.employeeId,
      date: record.date.toISOString().split('T')[0],
      entryTime: record.entryTime,
      exitTime: record.exitTime,
      status: record.status,
      shift: record.shift,
      observations: record.observations,
      status: record.status,
      observations: record.observations,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
      employee: {
        ...record.employee,
        workDays: JSON.parse(record.employee.workDays)
      }
    };

    res.json(formattedRecord);
  } catch (error) {
    console.error('Erro ao marcar falta:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
};
