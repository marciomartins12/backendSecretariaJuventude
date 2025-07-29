import { Router } from 'express';
import {
  getTimeRecords,
  getTodayRecords,
  createTimeRecord,
  deleteTimeRecord,
  clockInOut,
  getAttendanceReport,
  generateAbsenceRecords,
  markAbsence
} from '../controllers/timeRecordController';
import { authMiddleware } from '../middleware/auth';

const router = Router();

// Aplicar middleware de autenticação em todas as rotas
router.use(authMiddleware);

router.get('/', getTimeRecords);
router.get('/today', getTodayRecords);
router.get('/attendance-report', getAttendanceReport);
router.post('/', createTimeRecord);
router.post('/clock', clockInOut);
router.post('/generate-absences', generateAbsenceRecords);
router.post('/mark-absence', markAbsence);
router.delete('/:id', deleteTimeRecord);

export default router;
