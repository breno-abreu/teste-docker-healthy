-- Script manual: criação da tabela e dados mock (PostgreSQL 18)
-- Execute após criar o banco: psql -U root -d HealthyDataBase -f 02-create-table-and-seed.sql

CREATE TABLE IF NOT EXISTS "HealtyTable" (
    id SERIAL PRIMARY KEY,
    message VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL DEFAULT 'Geral'
);

CREATE TABLE IF NOT EXISTS "HealthyTaskTable" (
    id SERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    notes VARCHAR(255) NOT NULL
);

INSERT INTO "HealtyTable" (message, category) VALUES
    ('Sistema operacional', 'Infra'),
    ('Conexão com banco de dados OK', 'Banco'),
    ('Dados de teste carregados com sucesso', 'Seed');

INSERT INTO "HealthyTaskTable" (title, notes) VALUES
    ('Validar volume Docker', 'Confirmar persistencia apos docker compose down/up'),
    ('Atualizar backend', 'Rebuild apenas do serviço backend quando necessario'),
    ('Atualizar frontend', 'Rebuild apenas do serviço caddy quando a tela mudar');
