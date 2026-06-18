-- Executado automaticamente pelo container PostgreSQL 18 (POSTGRES_DB=HealthyDataBase)
-- Abordagem SQL-first: schema gerenciado manualmente, sem migrations
-- Compatível com PostgreSQL 18 (local ou Docker postgres:18-alpine)

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
