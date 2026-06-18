-- Script manual: criação do banco de dados (PostgreSQL 18)
-- Execute após 00-create-user.sql: psql -U postgres -f 01-create-database.sql

CREATE DATABASE "HealthyDataBase"
    WITH OWNER = root
    ENCODING = 'UTF8';
