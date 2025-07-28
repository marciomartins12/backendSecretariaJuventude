-- Criação das tabelas para o sistema de controle de ponto

USE crono_juventude;

-- Tabela de usuários
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(191) NOT NULL PRIMARY KEY,
    username VARCHAR(191) NOT NULL UNIQUE,
    password VARCHAR(191) NOT NULL,
    createdAt DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    updatedAt DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3)
);

-- Tabela de funcionários
CREATE TABLE IF NOT EXISTS employees (
    id VARCHAR(191) NOT NULL PRIMARY KEY,
    name VARCHAR(191) NOT NULL,
    position VARCHAR(191) NOT NULL,
    registration VARCHAR(191) NOT NULL UNIQUE,
    workDays TEXT NOT NULL,
    createdAt DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    updatedAt DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3)
);

-- Tabela de registros de ponto
CREATE TABLE IF NOT EXISTS time_records (
    id VARCHAR(191) NOT NULL PRIMARY KEY,
    employeeId VARCHAR(191) NOT NULL,
    date DATE NOT NULL,
    entryTime VARCHAR(191) NULL,
    exitTime VARCHAR(191) NULL,
    createdAt DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    updatedAt DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
    CONSTRAINT time_records_employeeId_fkey FOREIGN KEY (employeeId) REFERENCES employees(id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY time_records_employeeId_date_key (employeeId, date)
);

-- Inserir usuário admin padrão
INSERT INTO users (id, username, password) 
VALUES ('admin_id', 'admin', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewCu5e3z7mA0a8K2') 
ON DUPLICATE KEY UPDATE username = username;
-- Senha: admin123
