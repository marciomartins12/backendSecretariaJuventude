-- Corrigir status para apenas PRESENT/ABSENT

USE crono_juventude;

-- Primeiro, converter todos os status para PRESENT ou ABSENT
UPDATE time_records 
SET status = CASE 
    WHEN entryTime IS NOT NULL THEN 'PRESENT'
    ELSE 'ABSENT'
END;

-- Depois alterar a coluna para o novo enum
ALTER TABLE time_records 
MODIFY COLUMN status ENUM('PRESENT', 'ABSENT') DEFAULT 'PRESENT';

SELECT 'Status simplificado com sucesso!' as message;
