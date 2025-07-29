-- Corrigir enums no banco de dados

USE crono_juventude;

-- Primeiro, atualizar todos os registros para status válidos
UPDATE time_records 
SET status = CASE 
    WHEN entryTime IS NOT NULL THEN 'PRESENT'
    ELSE 'ABSENT'
END;

-- Alterar a coluna status para usar apenas PRESENT/ABSENT
ALTER TABLE time_records 
MODIFY COLUMN status ENUM('PRESENT', 'ABSENT') DEFAULT 'PRESENT';

-- Certificar que a coluna shift existe com valores corretos
ALTER TABLE time_records 
MODIFY COLUMN shift ENUM('MORNING', 'AFTERNOON', 'FULL_DAY') DEFAULT 'FULL_DAY';

-- Certificar que todos os registros têm um shift
UPDATE time_records 
SET shift = 'FULL_DAY' 
WHERE shift IS NULL;

SELECT 'Enums corrigidos com sucesso!' as message;
