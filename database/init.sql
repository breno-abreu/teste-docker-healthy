-- Executado automaticamente pelo container PostgreSQL 18 (POSTGRES_DB=HealthyDataBase)
-- Abordagem SQL-first: schema gerenciado manualmente, sem migrations
-- Compatível com PostgreSQL 18 (local ou Docker postgres:18-alpine)

CREATE TABLE IF NOT EXISTS "HealtyTable" (
    id SERIAL PRIMARY KEY,
    message VARCHAR(255) NOT NULL
);

INSERT INTO "HealtyTable" (message) VALUES
    ('Sistema operacional'),
    ('Conexão com banco de dados OK'),
    ('Dados de teste carregados com sucesso');
