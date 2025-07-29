-- Adicionar sistema de turnos ao banco

USE crono_juventude;

-- Adicionar coluna shift (turno) na tabela time_records
ALTER TABLE time_records 
ADD COLUMN IF NOT EXISTS shift ENUM('MORNING', 'AFTERNOON', 'FULL_DAY') DEFAULT 'FULL_DAY';

-- Atualizar registros existentes para FULL_DAY
UPDATE time_records 
SET shift = 'FULL_DAY' 
WHERE shift IS NULL;

SELECT 'Sistema de turnos adicionado!' as message;
