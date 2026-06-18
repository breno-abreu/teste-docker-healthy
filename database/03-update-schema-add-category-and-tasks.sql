-- Script manual de atualização SQL-first para bancos já existentes.
-- Execute na VM antes de subir backend/frontend atualizados:
-- psql -U root -d HealthyDataBase -f database/03-update-schema-add-category-and-tasks.sql

ALTER TABLE "HealtyTable"
    ADD COLUMN IF NOT EXISTS category VARCHAR(100) NOT NULL DEFAULT 'Geral';

UPDATE "HealtyTable"
SET category = 'Legado'
WHERE category = 'Geral';

CREATE TABLE IF NOT EXISTS "HealthyTaskTable" (
    id SERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    notes VARCHAR(255) NOT NULL
);

INSERT INTO "HealthyTaskTable" (title, notes)
SELECT seed.title, seed.notes
FROM (VALUES
    ('Validar volume Docker', 'Confirmar persistencia apos docker compose down/up'),
    ('Atualizar backend', 'Rebuild apenas do serviço backend quando necessario'),
    ('Atualizar frontend', 'Rebuild apenas do serviço caddy quando a tela mudar')
) AS seed(title, notes)
WHERE NOT EXISTS (
    SELECT 1
    FROM "HealthyTaskTable" existing
    WHERE existing.title = seed.title
);
