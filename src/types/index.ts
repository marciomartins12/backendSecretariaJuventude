export interface Employee {
  id: string;
  name: string;
  position: string;
  registration: string;
  workDays: string[];
  createdAt: Date;
  updatedAt: Date;
}

export interface TimeRecord {
  id: string;
  employeeId: string;
  date: string; // YYYY-MM-DD
  entryTime?: string; // HH:MM
  exitTime?: string; // HH:MM
  status: AttendanceStatus;
  shift: ShiftType;
  observations?: string;
  createdAt: Date;
  updatedAt: Date;
}

export enum AttendanceStatus {
  PRESENT = 'PRESENT',
  ABSENT = 'ABSENT'
}

export enum ShiftType {
  MORNING = 'MORNING',
  AFTERNOON = 'AFTERNOON', 
  FULL_DAY = 'FULL_DAY'
}

export interface User {
  id: string;
  username: string;
  createdAt: Date;
}

export interface AuthRequest {
  username: string;
  password: string;
}

export interface AuthResponse {
  token: string;
  user: User;
}

export type WeekDay = 'monday' | 'tuesday' | 'wednesday' | 'thursday' | 'friday' | 'saturday' | 'sunday';

export interface CreateEmployeeRequest {
  name: string;
  position: string;
  registration: string;
  workDays: WeekDay[];
}

export interface UpdateEmployeeRequest {
  name?: string;
  position?: string;
  registration?: string;
  workDays?: WeekDay[];
}

export interface CreateTimeRecordRequest {
  employeeId: string;
  date: string; // YYYY-MM-DD
  entryTime?: string; // HH:MM
  exitTime?: string; // HH:MM
  status?: AttendanceStatus;
  shift?: ShiftType;
  observations?: string;
}
