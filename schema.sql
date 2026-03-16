-- SQL Схема для базы данных (RU-Only Sales Bot)
-- Выполните этот скрипт в разделе SQL Editor в Supabase

-- 1. Таблица объектов недвижимости (Units)
CREATE TABLE IF NOT EXISTS public.units (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    project_id UUID,
    type VARCHAR(50) DEFAULT 'apartment',
    title VARCHAR(255),
    city VARCHAR(100),
    address TEXT,
    rooms VARCHAR(50),
    floor INTEGER,
    floors_total INTEGER,
    area_m2 NUMERIC,
    price NUMERIC,
    status VARCHAR(50) DEFAULT 'available',
    description TEXT,
    features JSONB DEFAULT '[]'::jsonb,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Таблица для фото объектов
CREATE TABLE IF NOT EXISTS public.unit_photos (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    unit_id UUID REFERENCES public.units(id) ON DELETE CASCADE,
    url TEXT NOT NULL,
    is_main BOOLEAN DEFAULT false,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Таблица лидов (Leads)
CREATE TABLE IF NOT EXISTS public.leads (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255),
    phone VARCHAR(50),
    email VARCHAR(255),
    city VARCHAR(100),
    budget_min NUMERIC,
    budget_max NUMERIC,
    source VARCHAR(50) DEFAULT 'telegram',
    source_bot_id VARCHAR(100),
    telegram_chat_id VARCHAR(100),
    data JSONB DEFAULT '{}'::jsonb,
    status VARCHAR(50) DEFAULT 'new',
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Таблица менеджеров в Telegram (для уведомлений о новых лидах)
CREATE TABLE IF NOT EXISTS public.telegram_managers (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    telegram_id BIGINT UNIQUE NOT NULL,
    name VARCHAR(255),
    is_active BOOLEAN DEFAULT true,
    preferred_lang VARCHAR(10) DEFAULT 'ru',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. База знаний и настройки (Bot Instructions, Company Info, Company Files)
CREATE TABLE IF NOT EXISTS public.bot_instructions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    rule_text TEXT NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.company_info (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    key VARCHAR(100) UNIQUE NOT NULL,
    value TEXT NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.company_files (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    file_type VARCHAR(50),
    url TEXT,
    category VARCHAR(100),
    content_text TEXT,
    sort_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. История сессий и сообщений (Sessions and Messages)
CREATE TABLE IF NOT EXISTS public.sessions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    bot_id VARCHAR(100),
    external_user_id VARCHAR(100),
    context JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.messages (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    session_id UUID REFERENCES public.sessions(id) ON DELETE CASCADE,
    bot_id VARCHAR(100),
    role VARCHAR(50),
    content TEXT,
    payload JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. Создание бакетов (Buckets) для загрузки файлов через Supabase Storage
INSERT INTO storage.buckets (id, name, public) 
VALUES ('unit_photos', 'unit_photos', true) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.buckets (id, name, public) 
VALUES ('company_files', 'company_files', true) 
ON CONFLICT (id) DO NOTHING;

-- Политики доступа на чтение (Public Access)
CREATE POLICY "public_unit_photos" ON storage.objects FOR SELECT USING (bucket_id = 'unit_photos');
CREATE POLICY "public_company_files" ON storage.objects FOR SELECT USING (bucket_id = 'company_files');

-- Политики доступа на добавление/редактирование
CREATE POLICY "auth_unit_photos" ON storage.objects FOR ALL USING (bucket_id = 'unit_photos');
CREATE POLICY "auth_company_files" ON storage.objects FOR ALL USING (bucket_id = 'company_files');
