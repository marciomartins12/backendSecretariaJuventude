-- Simplificar status para apenas PRESENT/ABSENT

USE crono_juventude;

-- Atualizar enum para apenas PRESENT/ABSENT
ALTER TABLE time_records 
MODIFY COLUMN status ENUM('PRESENT', 'ABSENT') DEFAULT 'PRESENT';

-- Atualizar registros existentes:
-- Se tem entryTime = PRESENT, se não tem = ABSENT
UPDATE time_records 
SET status = CASE 
    WHEN entryTime IS NOT NULL THEN 'PRESENT'
    ELSE 'ABSENT'
END;

SELECT 'Status simplificado para PRESENT/ABSENT!' as message;
