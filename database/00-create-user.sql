-- Script manual: criação do usuário root (PostgreSQL 18 local)
-- Execute como superusuário: psql -U postgres -f 00-create-user.sql

DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'root') THEN
        CREATE ROLE root WITH LOGIN PASSWORD 'zfu2vyaf' SUPERUSER CREATEDB;
    ELSE
        ALTER ROLE root WITH PASSWORD 'zfu2vyaf';
    END IF;
END
$$;
