-- Script manual: criação da tabela e dados mock (PostgreSQL 18)
-- Execute após criar o banco: psql -U root -d HealthyDataBase -f 02-create-table-and-seed.sql

CREATE TABLE IF NOT EXISTS "HealtyTable" (
    id SERIAL PRIMARY KEY,
    message VARCHAR(255) NOT NULL
);

INSERT INTO "HealtyTable" (message) VALUES
    ('Sistema operacional'),
    ('Conexão com banco de dados OK'),
    ('Dados de teste carregados com sucesso');
