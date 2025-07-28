import { Request, Response } from 'express';
import { z } from 'zod';
import prisma from '../utils/database';
import { CreateEmployeeRequest, UpdateEmployeeRequest, WeekDay } from '../types';

const weekDays: WeekDay[] = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];

const createEmployeeSchema = z.object({
  name: z.string().min(1, 'Nome é obrigatório'),
  position: z.string().min(1, 'Cargo é obrigatório'),
  registration: z.string().min(1, 'Matrícula é obrigatória'),
  workDays: z.array(z.enum(weekDays as [WeekDay, ...WeekDay[]])).min(1, 'Pelo menos um dia de trabalho é obrigatório')
});

const updateEmployeeSchema = createEmployeeSchema.partial();

export const getEmployees = async (req: Request, res: Response): Promise<void> => {
  try {
    const employees = await prisma.employee.findMany({
      orderBy: { createdAt: 'desc' }
    });

    const formattedEmployees = employees.map(employee => ({
      ...employee,
      workDays: JSON.parse(employee.workDays)
    }));

    res.json(formattedEmployees);
  } catch (error) {
    console.error('Erro ao buscar funcionários:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
};

export const getEmployeeById = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;

    const employee = await prisma.employee.findUnique({
      where: { id }
    });

    if (!employee) {
      res.status(404).json({ error: 'Funcionário não encontrado' });
      return;
    }

    const formattedEmployee = {
      ...employee,
      workDays: JSON.parse(employee.workDays)
    };

    res.json(formattedEmployee);
  } catch (error) {
    console.error('Erro ao buscar funcionário:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
};

export const createEmployee = async (req: Request, res: Response): Promise<void> => {
  try {
    const data: CreateEmployeeRequest = createEmployeeSchema.parse(req.body);

    // Verificar se matrícula já existe
    const existingEmployee = await prisma.employee.findUnique({
      where: { registration: data.registration }
    });

    if (existingEmployee) {
      res.status(400).json({ error: 'Matrícula já existe' });
      return;
    }

    const employee = await prisma.employee.create({
      data: {
        ...data,
        workDays: JSON.stringify(data.workDays)
      }
    });

    const formattedEmployee = {
      ...employee,
      workDays: JSON.parse(employee.workDays)
    };

    res.status(201).json(formattedEmployee);
  } catch (error) {
    if (error instanceof z.ZodError) {
      res.status(400).json({ error: error.errors[0].message });
      return;
    }

    console.error('Erro ao criar funcionário:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
};

export const updateEmployee = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const data: UpdateEmployeeRequest = updateEmployeeSchema.parse(req.body);

    const existingEmployee = await prisma.employee.findUnique({
      where: { id }
    });

    if (!existingEmployee) {
      res.status(404).json({ error: 'Funcionário não encontrado' });
      return;
    }

    // Verificar se a nova matrícula já existe (se foi alterada)
    if (data.registration && data.registration !== existingEmployee.registration) {
      const employeeWithSameRegistration = await prisma.employee.findUnique({
        where: { registration: data.registration }
      });

      if (employeeWithSameRegistration) {
        res.status(400).json({ error: 'Matrícula já existe' });
        return;
      }
    }

    const updateData: any = { ...data };
    if (data.workDays) {
      updateData.workDays = JSON.stringify(data.workDays);
    }

    const employee = await prisma.employee.update({
      where: { id },
      data: updateData
    });

    const formattedEmployee = {
      ...employee,
      workDays: JSON.parse(employee.workDays)
    };

    res.json(formattedEmployee);
  } catch (error) {
    if (error instanceof z.ZodError) {
      res.status(400).json({ error: error.errors[0].message });
      return;
    }

    console.error('Erro ao atualizar funcionário:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
};

export const deleteEmployee = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;

    const existingEmployee = await prisma.employee.findUnique({
      where: { id }
    });

    if (!existingEmployee) {
      res.status(404).json({ error: 'Funcionário não encontrado' });
      return;
    }

    await prisma.employee.delete({
      where: { id }
    });

    res.status(204).send();
  } catch (error) {
    console.error('Erro ao deletar funcionário:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
};

export const getScheduledEmployeesToday = async (req: Request, res: Response): Promise<void> => {
  try {
    const today = new Date();
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

    const employees = await prisma.employee.findMany();
    
    const scheduledEmployees = employees.filter(employee => {
      const workDays = JSON.parse(employee.workDays);
      return workDays.includes(dayOfWeek);
    }).map(employee => ({
      ...employee,
      workDays: JSON.parse(employee.workDays)
    }));

    res.json(scheduledEmployees);
  } catch (error) {
    console.error('Erro ao buscar funcionários escalados hoje:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
};
