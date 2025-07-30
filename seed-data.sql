-- Script SQL para adicionar dados fictícios no banco de dados
-- Execute este script no MySQL/MariaDB

USE crono_juventude;

-- Limpar dados existentes (exceto usuários)
DELETE FROM time_records;
DELETE FROM employees;

-- Inserir funcionários fictícios
INSERT INTO employees (id, name, position, registration, workDays, createdAt, updatedAt) VALUES
('emp_001', 'Ana Silva Santos', 'Coordenadora de Juventude', 'JUV001', '["monday","tuesday","wednesday","thursday","friday"]', NOW(), NOW()),
('emp_002', 'Carlos Eduardo Oliveira', 'Educador Social', 'JUV002', '["monday","tuesday","wednesday","thursday","friday"]', NOW(), NOW()),
('emp_003', 'Maria Fernanda Costa', 'Psicóloga', 'JUV003', '["tuesday","wednesday","thursday"]', NOW(), NOW()),
('emp_004', 'João Pedro Santos', 'Instrutor de Esportes', 'JUV004', '["monday","wednesday","friday"]', NOW(), NOW()),
('emp_005', 'Letícia Almeida', 'Arte-Educadora', 'JUV005', '["tuesday","thursday","saturday"]', NOW(), NOW()),
('emp_006', 'Roberto Carlos Lima', 'Mediador Cultural', 'JUV006', '["monday","tuesday","wednesday","thursday","friday"]', NOW(), NOW()),
('emp_007', 'Juliana Ribeiro', 'Assistente Social', 'JUV007', '["monday","wednesday","friday"]', NOW(), NOW()),
('emp_008', 'Fernando Mendes', 'Instrutor de Informática', 'JUV008', '["tuesday","thursday"]', NOW(), NOW()),
('emp_009', 'Camila Souza', 'Auxiliar Administrativa', 'JUV009', '["monday","tuesday","wednesday","thursday","friday"]', NOW(), NOW()),
('emp_010', 'Rafael Machado', 'Monitor de Atividades', 'JUV010', '["monday","tuesday","wednesday","thursday","friday","saturday"]', NOW(), NOW()),
('emp_011', 'Patricia Gomes', 'Nutricionista', 'JUV011', '["wednesday","friday"]', NOW(), NOW()),
('emp_012', 'Gabriel Ferreira', 'Monitor de Esportes', 'JUV012', '["monday","wednesday","friday","saturday"]', NOW(), NOW()),
('emp_013', 'Amanda Torres', 'Pedagoga', 'JUV013', '["tuesday","wednesday","thursday"]', NOW(), NOW()),
('emp_014', 'Lucas Rodrigues', 'Auxiliar de Limpeza', 'JUV014', '["monday","tuesday","wednesday","thursday","friday"]', NOW(), NOW()),
('emp_015', 'Isabela Martins', 'Recepcionista', 'JUV015', '["monday","tuesday","wednesday","thursday","friday"]', NOW(), NOW());

-- Inserir registros de ponto dos últimos 30 dias
-- Semana atual (alguns registros de hoje)
INSERT INTO time_records (id, employeeId, date, entryTime, exitTime, status, shift, observations, createdAt, updatedAt) VALUES
('rec_today_001', 'emp_001', CURDATE(), '07:45', '17:30', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_today_002', 'emp_002', CURDATE(), '08:00', NULL, 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_today_003', 'emp_003', CURDATE(), NULL, NULL, 'ABSENT', 'FULL_DAY', 'Consulta médica', NOW(), NOW()),
('rec_today_004', 'emp_006', CURDATE(), '07:30', '17:45', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_today_005', 'emp_009', CURDATE(), '08:15', NULL, 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_today_006', 'emp_010', CURDATE(), '07:50', '16:45', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_today_007', 'emp_014', CURDATE(), '08:00', '17:00', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_today_008', 'emp_015', CURDATE(), '08:30', NULL, 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW());

-- Ontem
INSERT INTO time_records (id, employeeId, date, entryTime, exitTime, status, shift, observations, createdAt, updatedAt) VALUES
('rec_yesterday_001', 'emp_001', DATE_SUB(CURDATE(), INTERVAL 1 DAY), '07:50', '17:20', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_yesterday_002', 'emp_002', DATE_SUB(CURDATE(), INTERVAL 1 DAY), '08:10', '17:30', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_yesterday_003', 'emp_006', DATE_SUB(CURDATE(), INTERVAL 1 DAY), '07:45', '17:45', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_yesterday_004', 'emp_009', DATE_SUB(CURDATE(), INTERVAL 1 DAY), '08:00', '17:15', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_yesterday_005', 'emp_010', DATE_SUB(CURDATE(), INTERVAL 1 DAY), '07:55', '16:50', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_yesterday_006', 'emp_014', DATE_SUB(CURDATE(), INTERVAL 1 DAY), '08:05', '17:05', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_yesterday_007', 'emp_015', DATE_SUB(CURDATE(), INTERVAL 1 DAY), '08:15', '17:25', 'PRESENT', 'FULL_DAY', NULL, NOW()),
('rec_yesterday_008', 'emp_004', DATE_SUB(CURDATE(), INTERVAL 1 DAY), '08:00', '17:00', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_yesterday_009', 'emp_007', DATE_SUB(CURDATE(), INTERVAL 1 DAY), '07:40', '17:10', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW());

-- Há 2 dias
INSERT INTO time_records (id, employeeId, date, entryTime, exitTime, status, shift, observations, createdAt, updatedAt) VALUES
('rec_2days_001', 'emp_001', DATE_SUB(CURDATE(), INTERVAL 2 DAY), '07:55', '17:35', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_2days_002', 'emp_002', DATE_SUB(CURDATE(), INTERVAL 2 DAY), '08:00', '17:25', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_2days_003', 'emp_003', DATE_SUB(CURDATE(), INTERVAL 2 DAY), '08:30', '12:00', 'PRESENT', 'MORNING', 'Trabalhou apenas pela manhã', NOW(), NOW()),
('rec_2days_004', 'emp_006', DATE_SUB(CURDATE(), INTERVAL 2 DAY), '07:40', '17:40', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_2days_005', 'emp_009', DATE_SUB(CURDATE(), INTERVAL 2 DAY), '08:20', '17:20', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_2days_006', 'emp_010', DATE_SUB(CURDATE(), INTERVAL 2 DAY), '07:45', '16:55', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_2days_007', 'emp_013', DATE_SUB(CURDATE(), INTERVAL 2 DAY), '08:00', '17:00', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_2days_008', 'emp_014', DATE_SUB(CURDATE(), INTERVAL 2 DAY), '08:10', '17:10', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_2days_009', 'emp_015', DATE_SUB(CURDATE(), INTERVAL 2 DAY), '08:25', '17:30', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW());

-- Há 3 dias  
INSERT INTO time_records (id, employeeId, date, entryTime, exitTime, status, shift, observations, createdAt, updatedAt) VALUES
('rec_3days_001', 'emp_001', DATE_SUB(CURDATE(), INTERVAL 3 DAY), '07:50', '17:25', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_3days_002', 'emp_002', DATE_SUB(CURDATE(), INTERVAL 3 DAY), '08:05', '17:35', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_3days_003', 'emp_004', DATE_SUB(CURDATE(), INTERVAL 3 DAY), '07:45', '17:15', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_3days_004', 'emp_006', DATE_SUB(CURDATE(), INTERVAL 3 DAY), '07:35', '17:50', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_3days_005', 'emp_007', DATE_SUB(CURDATE(), INTERVAL 3 DAY), '08:00', '17:05', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_3days_006', 'emp_009', DATE_SUB(CURDATE(), INTERVAL 3 DAY), '08:15', '17:15', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_3days_007', 'emp_010', DATE_SUB(CURDATE(), INTERVAL 3 DAY), '07:55', '16:45', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_3days_008', 'emp_014', DATE_SUB(CURDATE(), INTERVAL 3 DAY), '08:00', '17:00', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_3days_009', 'emp_015', DATE_SUB(CURDATE(), INTERVAL 3 DAY), '08:20', '17:25', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW());

-- Há 4 dias (com algumas faltas)
INSERT INTO time_records (id, employeeId, date, entryTime, exitTime, status, shift, observations, createdAt, updatedAt) VALUES
('rec_4days_001', 'emp_001', DATE_SUB(CURDATE(), INTERVAL 4 DAY), '07:45', '17:30', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_4days_002', 'emp_002', DATE_SUB(CURDATE(), INTERVAL 4 DAY), NULL, NULL, 'ABSENT', 'FULL_DAY', 'Atestado médico', NOW(), NOW()),
('rec_4days_003', 'emp_005', DATE_SUB(CURDATE(), INTERVAL 4 DAY), '08:00', '17:00', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_4days_004', 'emp_006', DATE_SUB(CURDATE(), INTERVAL 4 DAY), '07:40', '17:45', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_4days_005', 'emp_008', DATE_SUB(CURDATE(), INTERVAL 4 DAY), '08:30', '17:30', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_4days_006', 'emp_009', DATE_SUB(CURDATE(), INTERVAL 4 DAY), '08:10', '17:20', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_4days_007', 'emp_010', DATE_SUB(CURDATE(), INTERVAL 4 DAY), '07:50', '16:50', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_4days_008', 'emp_014', DATE_SUB(CURDATE(), INTERVAL 4 DAY), '08:05', '17:05', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_4days_009', 'emp_015', DATE_SUB(CURDATE(), INTERVAL 4 DAY), '08:25', '17:30', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW());

-- Há 5 dias
INSERT INTO time_records (id, employeeId, date, entryTime, exitTime, status, shift, observations, createdAt, updatedAt) VALUES
('rec_5days_001', 'emp_001', DATE_SUB(CURDATE(), INTERVAL 5 DAY), '07:55', '17:25', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_5days_002', 'emp_002', DATE_SUB(CURDATE(), INTERVAL 5 DAY), '08:00', '17:30', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_5days_003', 'emp_004', DATE_SUB(CURDATE(), INTERVAL 5 DAY), '07:50', '17:10', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_5days_004', 'emp_006', DATE_SUB(CURDATE(), INTERVAL 5 DAY), '07:45', '17:40', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_5days_005', 'emp_007', DATE_SUB(CURDATE(), INTERVAL 5 DAY), '08:10', '17:15', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_5days_006', 'emp_009', DATE_SUB(CURDATE(), INTERVAL 5 DAY), '08:20', '17:20', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_5days_007', 'emp_010', DATE_SUB(CURDATE(), INTERVAL 5 DAY), '07:40', '16:55', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_5days_008', 'emp_012', DATE_SUB(CURDATE(), INTERVAL 5 DAY), '08:00', '17:00', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_5days_009', 'emp_014', DATE_SUB(CURDATE(), INTERVAL 5 DAY), '08:15', '17:10', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_5days_010', 'emp_015', DATE_SUB(CURDATE(), INTERVAL 5 DAY), '08:30', '17:35', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW());

-- Semana passada (mais registros variados)
INSERT INTO time_records (id, employeeId, date, entryTime, exitTime, status, shift, observations, createdAt, updatedAt) VALUES
('rec_week1_001', 'emp_001', DATE_SUB(CURDATE(), INTERVAL 7 DAY), '07:45', '17:30', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week1_002', 'emp_002', DATE_SUB(CURDATE(), INTERVAL 7 DAY), '08:05', '17:25', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week1_003', 'emp_003', DATE_SUB(CURDATE(), INTERVAL 7 DAY), NULL, NULL, 'ABSENT', 'FULL_DAY', 'Questões familiares', NOW(), NOW()),
('rec_week1_004', 'emp_006', DATE_SUB(CURDATE(), INTERVAL 7 DAY), '07:50', '17:45', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week1_005', 'emp_009', DATE_SUB(CURDATE(), INTERVAL 7 DAY), '08:00', '17:15', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week1_006', 'emp_010', DATE_SUB(CURDATE(), INTERVAL 7 DAY), '07:55', '16:50', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week1_007', 'emp_014', DATE_SUB(CURDATE(), INTERVAL 7 DAY), '08:10', '17:05', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week1_008', 'emp_015', DATE_SUB(CURDATE(), INTERVAL 7 DAY), '08:20', '17:30', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW());

INSERT INTO time_records (id, employeeId, date, entryTime, exitTime, status, shift, observations, createdAt, updatedAt) VALUES
('rec_week1_009', 'emp_001', DATE_SUB(CURDATE(), INTERVAL 8 DAY), '07:40', '17:35', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week1_010', 'emp_002', DATE_SUB(CURDATE(), INTERVAL 8 DAY), '08:00', '17:20', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week1_011', 'emp_005', DATE_SUB(CURDATE(), INTERVAL 8 DAY), '13:00', '18:00', 'PRESENT', 'AFTERNOON', 'Trabalhou apenas pela tarde', NOW(), NOW()),
('rec_week1_012', 'emp_006', DATE_SUB(CURDATE(), INTERVAL 8 DAY), '07:45', '17:40', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week1_013', 'emp_008', DATE_SUB(CURDATE(), INTERVAL 8 DAY), '08:30', '17:30', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week1_014', 'emp_009', DATE_SUB(CURDATE(), INTERVAL 8 DAY), '08:15', '17:25', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week1_015', 'emp_010', DATE_SUB(CURDATE(), INTERVAL 8 DAY), '07:50', '16:45', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week1_016', 'emp_014', DATE_SUB(CURDATE(), INTERVAL 8 DAY), '08:05', '17:10', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week1_017', 'emp_015', DATE_SUB(CURDATE(), INTERVAL 8 DAY), '08:25', '17:35', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW());

-- Mais alguns registros com faltas e meio período
INSERT INTO time_records (id, employeeId, date, entryTime, exitTime, status, shift, observations, createdAt, updatedAt) VALUES
('rec_week1_018', 'emp_003', DATE_SUB(CURDATE(), INTERVAL 9 DAY), '08:00', '12:00', 'PRESENT', 'MORNING', 'Consulta médica à tarde', NOW(), NOW()),
('rec_week1_019', 'emp_004', DATE_SUB(CURDATE(), INTERVAL 9 DAY), '07:45', '17:15', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week1_020', 'emp_007', DATE_SUB(CURDATE(), INTERVAL 9 DAY), NULL, NULL, 'ABSENT', 'FULL_DAY', 'Licença médica', NOW(), NOW()),
('rec_week1_021', 'emp_011', DATE_SUB(CURDATE(), INTERVAL 9 DAY), '08:00', '17:00', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week1_022', 'emp_012', DATE_SUB(CURDATE(), INTERVAL 9 DAY), '07:30', '16:30', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW());

INSERT INTO time_records (id, employeeId, date, entryTime, exitTime, status, shift, observations, createdAt, updatedAt) VALUES
('rec_week1_023', 'emp_001', DATE_SUB(CURDATE(), INTERVAL 10 DAY), '07:55', '17:30', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week1_024', 'emp_002', DATE_SUB(CURDATE(), INTERVAL 10 DAY), '08:10', '17:25', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week1_025', 'emp_006', DATE_SUB(CURDATE(), INTERVAL 10 DAY), '07:40', '17:50', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week1_026', 'emp_009', DATE_SUB(CURDATE(), INTERVAL 10 DAY), '08:00', '17:20', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week1_027', 'emp_010', DATE_SUB(CURDATE(), INTERVAL 10 DAY), '07:45', '16:55', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week1_028', 'emp_013', DATE_SUB(CURDATE(), INTERVAL 10 DAY), '08:15', '17:15', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week1_029', 'emp_014', DATE_SUB(CURDATE(), INTERVAL 10 DAY), '08:20', '17:00', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week1_030', 'emp_015', DATE_SUB(CURDATE(), INTERVAL 10 DAY), '08:30', '17:40', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW());

-- Mais alguns registros antigos (duas semanas atrás)
INSERT INTO time_records (id, employeeId, date, entryTime, exitTime, status, shift, observations, createdAt, updatedAt) VALUES
('rec_week2_001', 'emp_001', DATE_SUB(CURDATE(), INTERVAL 14 DAY), '07:50', '17:25', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week2_002', 'emp_002', DATE_SUB(CURDATE(), INTERVAL 14 DAY), NULL, NULL, 'ABSENT', 'FULL_DAY', 'Falta justificada', NOW(), NOW()),
('rec_week2_003', 'emp_004', DATE_SUB(CURDATE(), INTERVAL 14 DAY), '08:00', '17:00', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week2_004', 'emp_006', DATE_SUB(CURDATE(), INTERVAL 14 DAY), '07:35', '17:45', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week2_005', 'emp_007', DATE_SUB(CURDATE(), INTERVAL 14 DAY), '08:10', '17:10', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week2_006', 'emp_009', DATE_SUB(CURDATE(), INTERVAL 14 DAY), '08:05', '17:30', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week2_007', 'emp_010', DATE_SUB(CURDATE(), INTERVAL 14 DAY), '07:55', '16:50', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week2_008', 'emp_012', DATE_SUB(CURDATE(), INTERVAL 14 DAY), '07:45', '16:45', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week2_009', 'emp_014', DATE_SUB(CURDATE(), INTERVAL 14 DAY), '08:15', '17:05', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week2_010', 'emp_015', DATE_SUB(CURDATE(), INTERVAL 14 DAY), '08:25', '17:35', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW());

-- Registros mais antigos (3 semanas atrás) com mais variedade
INSERT INTO time_records (id, employeeId, date, entryTime, exitTime, status, shift, observations, createdAt, updatedAt) VALUES
('rec_week3_001', 'emp_001', DATE_SUB(CURDATE(), INTERVAL 21 DAY), '07:45', '17:30', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week3_002', 'emp_003', DATE_SUB(CURDATE(), INTERVAL 21 DAY), '13:30', '18:00', 'PRESENT', 'AFTERNOON', 'Reunião pela manhã', NOW(), NOW()),
('rec_week3_003', 'emp_005', DATE_SUB(CURDATE(), INTERVAL 21 DAY), NULL, NULL, 'ABSENT', 'FULL_DAY', 'Problema de transporte', NOW(), NOW()),
('rec_week3_004', 'emp_008', DATE_SUB(CURDATE(), INTERVAL 21 DAY), '08:00', '12:00', 'PRESENT', 'MORNING', 'Curso de capacitação à tarde', NOW(), NOW()),
('rec_week3_005', 'emp_011', DATE_SUB(CURDATE(), INTERVAL 21 DAY), '08:30', '17:30', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW()),
('rec_week3_006', 'emp_013', DATE_SUB(CURDATE(), INTERVAL 21 DAY), '08:00', '17:00', 'PRESENT', 'FULL_DAY', NULL, NOW(), NOW());

-- Verificar total de registros inseridos
SELECT 'Funcionários inseridos:' as info, COUNT(*) as total FROM employees
UNION ALL
SELECT 'Registros de ponto inseridos:' as info, COUNT(*) as total FROM time_records
UNION ALL
SELECT 'Registros PRESENT:' as info, COUNT(*) as total FROM time_records WHERE status = 'PRESENT'
UNION ALL
SELECT 'Registros ABSENT:' as info, COUNT(*) as total FROM time_records WHERE status = 'ABSENT';
