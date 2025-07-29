-- Adicionar colunas para controle de faltas na tabela time_records

USE crono_juventude;

-- Adicionar coluna status se não existir
ALTER TABLE time_records 
ADD COLUMN IF NOT EXISTS status ENUM('PRESENT', 'ABSENT', 'LATE', 'EARLY_EXIT', 'PARTIAL', 'JUSTIFIED') DEFAULT 'PRESENT';

-- Adicionar coluna observations se não existir
ALTER TABLE time_records 
ADD COLUMN IF NOT EXISTS observations TEXT NULL;

-- Atualizar registros existentes para ter status PRESENT se tiverem horários
UPDATE time_records 
SET status = 'PRESENT' 
WHERE entryTime IS NOT NULL AND exitTime IS NOT NULL AND status = 'PRESENT';

-- Atualizar registros incompletos para PARTIAL
UPDATE time_records 
SET status = 'PARTIAL' 
WHERE (entryTime IS NULL OR exitTime IS NULL) AND status = 'PRESENT';

SELECT 'Schema atualizado com sucesso!' as message;
