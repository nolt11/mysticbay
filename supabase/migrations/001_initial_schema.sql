-- MysticBay — Initial Schema
-- Run this in your Supabase SQL editor

-- ─── Extensions ──────────────────────────────────────────────
create extension if not exists "uuid-ossp";

-- ─── Profiles ────────────────────────────────────────────────
create table public.profiles (
  id uuid references auth.users on delete cascade primary key,
  email text not null,
  full_name text,
  avatar_url text,
  business_name text,
  business_logo_url text,
  subscription_tier text not null default 'free' check (subscription_tier in ('free', 'pro', 'studio')),
  stripe_customer_id text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Auto-create profile on signup
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, email, full_name, avatar_url)
  values (
    new.id,
    new.email,
    new.raw_user_meta_data->>'full_name',
    new.raw_user_meta_data->>'avatar_url'
  );
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ─── Clients ─────────────────────────────────────────────────
create table public.clients (
  id uuid primary key default uuid_generate_v4(),
  designer_id uuid references public.profiles(id) on delete cascade not null,
  full_name text not null,
  email text not null,
  phone text,
  company text,
  address text,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- ─── Projects ────────────────────────────────────────────────
create table public.projects (
  id uuid primary key default uuid_generate_v4(),
  designer_id uuid references public.profiles(id) on delete cascade not null,
  client_id uuid references public.clients(id) on delete set null,
  title text not null,
  description text,
  status text not null default 'active' check (status in ('active', 'on_hold', 'completed', 'archived')),
  cover_image_url text,
  client_portal_token uuid not null default uuid_generate_v4() unique,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- ─── Boards (Moodboards) ─────────────────────────────────────
create table public.boards (
  id uuid primary key default uuid_generate_v4(),
  project_id uuid references public.projects(id) on delete cascade not null,
  title text not null default 'Untitled Board',
  canvas_json text not null default '{}',
  thumbnail_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- ─── Products ────────────────────────────────────────────────
create table public.products (
  id uuid primary key default uuid_generate_v4(),
  project_id uuid references public.projects(id) on delete cascade not null,
  name text not null,
  vendor text,
  price numeric(10, 2),
  currency text not null default 'USD',
  quantity integer not null default 1,
  image_url text,
  product_url text,
  sku text,
  notes text,
  status text not null default 'considering' check (status in ('considering', 'approved', 'ordered', 'delivered')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- ─── Invoices ────────────────────────────────────────────────
create table public.invoices (
  id uuid primary key default uuid_generate_v4(),
  designer_id uuid references public.profiles(id) on delete cascade not null,
  client_id uuid references public.clients(id) on delete restrict not null,
  project_id uuid references public.projects(id) on delete set null,
  invoice_number text not null,
  status text not null default 'draft' check (status in ('draft', 'sent', 'paid', 'overdue', 'cancelled')),
  line_items jsonb not null default '[]',
  subtotal numeric(10, 2) not null default 0,
  tax_rate numeric(5, 2) not null default 0,
  tax_amount numeric(10, 2) not null default 0,
  total numeric(10, 2) not null default 0,
  currency text not null default 'USD',
  due_date date not null,
  paid_at timestamptz,
  notes text,
  stripe_payment_intent_id text,
  stripe_payment_link text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- ─── Contracts ───────────────────────────────────────────────
create table public.contracts (
  id uuid primary key default uuid_generate_v4(),
  designer_id uuid references public.profiles(id) on delete cascade not null,
  client_id uuid references public.clients(id) on delete restrict not null,
  project_id uuid references public.projects(id) on delete set null,
  title text not null,
  body text not null,
  status text not null default 'draft' check (status in ('draft', 'sent', 'signed', 'cancelled')),
  client_signature text,
  client_signed_at timestamptz,
  client_ip_address text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- ─── Comments ────────────────────────────────────────────────
create table public.comments (
  id uuid primary key default uuid_generate_v4(),
  project_id uuid references public.projects(id) on delete cascade not null,
  board_id uuid references public.boards(id) on delete cascade,
  author_name text not null,
  author_type text not null check (author_type in ('designer', 'client')),
  body text not null,
  created_at timestamptz not null default now()
);

-- ─── Intake Forms ────────────────────────────────────────────
create table public.intake_forms (
  id uuid primary key default uuid_generate_v4(),
  designer_id uuid references public.profiles(id) on delete cascade not null,
  title text not null,
  fields jsonb not null default '[]',
  created_at timestamptz not null default now()
);

create table public.intake_form_responses (
  id uuid primary key default uuid_generate_v4(),
  form_id uuid references public.intake_forms(id) on delete cascade not null,
  client_id uuid references public.clients(id) on delete set null,
  responses jsonb not null default '{}',
  submitted_at timestamptz not null default now()
);

-- ─── Row Level Security ──────────────────────────────────────

alter table public.profiles enable row level security;
alter table public.clients enable row level security;
alter table public.projects enable row level security;
alter table public.boards enable row level security;
alter table public.products enable row level security;
alter table public.invoices enable row level security;
alter table public.contracts enable row level security;
alter table public.comments enable row level security;
alter table public.intake_forms enable row level security;
alter table public.intake_form_responses enable row level security;

-- Profiles: users can only see/edit their own
create policy "profiles_own" on public.profiles for all using (auth.uid() = id);

-- Clients: designers own their clients
create policy "clients_own" on public.clients for all using (auth.uid() = designer_id);

-- Projects: designers own their projects
create policy "projects_own" on public.projects for all using (auth.uid() = designer_id);

-- Boards: accessible if you own the project
create policy "boards_own" on public.boards for all using (
  exists (select 1 from public.projects where id = boards.project_id and designer_id = auth.uid())
);

-- Products: accessible if you own the project
create policy "products_own" on public.products for all using (
  exists (select 1 from public.projects where id = products.project_id and designer_id = auth.uid())
);

-- Invoices: designers own their invoices
create policy "invoices_own" on public.invoices for all using (auth.uid() = designer_id);

-- Contracts: designers own their contracts
create policy "contracts_own" on public.contracts for all using (auth.uid() = designer_id);

-- Comments: accessible if you own the project
create policy "comments_own" on public.comments for all using (
  exists (select 1 from public.projects where id = comments.project_id and designer_id = auth.uid())
);

-- Intake forms: designers own their forms
create policy "intake_forms_own" on public.intake_forms for all using (auth.uid() = designer_id);

-- ─── Indexes ─────────────────────────────────────────────────

create index on public.projects (designer_id);
create index on public.projects (client_id);
create index on public.projects (client_portal_token);
create index on public.clients (designer_id);
create index on public.boards (project_id);
create index on public.products (project_id);
create index on public.invoices (designer_id);
create index on public.invoices (client_id);
create index on public.contracts (designer_id);
create index on public.comments (project_id);
