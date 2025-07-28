import { Request, Response } from 'express';
import { z } from 'zod';
import prisma from '../utils/database';
import { comparePassword, generateToken, hashPassword } from '../utils/auth';
import { AuthRequest } from '../types';

const loginSchema = z.object({
  username: z.string().min(1, 'Username é obrigatório'),
  password: z.string().min(1, 'Password é obrigatório')
});

export const login = async (req: Request, res: Response): Promise<void> => {
  try {
    const { username, password }: AuthRequest = loginSchema.parse(req.body);

    // Buscar usuário
    const user = await prisma.user.findUnique({
      where: { username }
    });

    if (!user) {
      res.status(401).json({ error: 'Credenciais inválidas' });
      return;
    }

    // Verificar senha
    const isValidPassword = await comparePassword(password, user.password);

    if (!isValidPassword) {
      res.status(401).json({ error: 'Credenciais inválidas' });
      return;
    }

    // Gerar token
    const token = generateToken(user.id);

    res.json({
      token,
      user: {
        id: user.id,
        username: user.username,
        createdAt: user.createdAt
      }
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      res.status(400).json({ error: error.errors[0].message });
      return;
    }
    
    console.error('Erro no login:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
};

export const createDefaultUser = async () => {
  try {
    const existingUser = await prisma.user.findUnique({
      where: { username: 'admin' }
    });

    if (!existingUser) {
      const hashedPassword = await hashPassword('admin123');
      console.log({hashPassword:"senha"})
      await prisma.user.create({
        data: {
          username: 'admin',
          password: hashedPassword
        }
      });

      console.log('Usuário admin criado com sucesso');
    }
  } catch (error) {
    console.error('Erro ao criar usuário padrão:', error);
  }
};
