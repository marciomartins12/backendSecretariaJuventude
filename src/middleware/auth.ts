import { Request, Response, NextFunction } from 'express';
import { verifyToken } from '../utils/auth';
import prisma from '../utils/database';

export interface AuthenticatedRequest extends Request {
  userId?: string;
}

export const authMiddleware = async (
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      res.status(401).json({ error: 'Token não fornecido' });
      return;
    }

    const token = authHeader.substring(7);
    const userId = verifyToken(token);

    if (!userId) {
      res.status(401).json({ error: 'Token inválido' });
      return;
    }

    // Verificar se o usuário ainda existe
    const user = await prisma.user.findUnique({
      where: { id: userId }
    });

    if (!user) {
      res.status(401).json({ error: 'Usuário não encontrado' });
      return;
    }

    req.userId = userId;
    next();
  } catch (error) {
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
};
