-- ============================================================
-- Dental Clinic Management System — Supabase Schema
-- Run this in the Supabase SQL Editor after creating your project
-- ============================================================

-- 1. Users table (extends Supabase auth.users)
create table public.users (
  id          uuid references auth.users on delete cascade primary key,
  full_name   text not null,
  phone       text,
  role        text not null check (role in ('doctor', 'secretary', 'patient')),
  created_at  timestamptz default now()
);
alter table public.users enable row level security;

-- 2. Patients
create table public.patients (
  id           uuid default gen_random_uuid() primary key,
  user_id      uuid references public.users on delete set null,
  full_name    text not null,
  phone        text,
  birth_date   date,
  gender       text check (gender in ('male', 'female')),
  notes        text,
  created_at   timestamptz default now(),
  updated_at   timestamptz default now()
);
alter table public.patients enable row level security;

-- 3. Appointments
create table public.appointments (
  id           uuid default gen_random_uuid() primary key,
  patient_id   uuid references public.patients on delete cascade not null,
  doctor_id    uuid references public.users on delete cascade not null,
  date         date not null,
  start_time   time not null,
  end_time     time not null,
  status       text default 'pending' check (status in ('pending','confirmed','completed','cancelled')),
  procedure_type text,
  notes        text,
  created_at   timestamptz default now()
);
alter table public.appointments enable row level security;

-- 4. Dental records (per tooth per visit)
create table public.dental_records (
  id             uuid default gen_random_uuid() primary key,
  patient_id     uuid references public.patients on delete cascade not null,
  doctor_id      uuid references public.users on delete cascade not null,
  appointment_id uuid references public.appointments on delete set null,
  tooth_number   int not null check (tooth_number between 1 and 32),
  procedure_type text not null,
  notes          text,
  created_at     timestamptz default now()
);
alter table public.dental_records enable row level security;

-- 5. Billing
create table public.billing (
  id             uuid default gen_random_uuid() primary key,
  patient_id     uuid references public.patients on delete cascade not null,
  appointment_id uuid references public.appointments on delete set null,
  total_amount   numeric(10,2) not null,
  paid_amount    numeric(10,2) default 0,
  discount       numeric(10,2) default 0,
  payment_method text check (payment_method in ('cash', 'shami_cash', 'transfer')),
  notes          text,
  created_at     timestamptz default now()
);
alter table public.billing enable row level security;

-- ============================================================
-- Indexes
-- ============================================================
create index idx_appointments_date on public.appointments(date);
create index idx_appointments_doctor on public.appointments(doctor_id);
create index idx_appointments_patient on public.appointments(patient_id);
create index idx_dental_records_patient on public.dental_records(patient_id);
create index idx_billing_patient on public.billing(patient_id);

-- ============================================================
-- RLS Policies
-- ============================================================
-- Users: can read own record; doctors/secretaries can read all
create policy "users_self" on public.users
  for select using (auth.uid() = id);
create policy "users_staff_select" on public.users
  for select using (
    exists (select 1 from public.users where id = auth.uid() and role in ('doctor','secretary'))
  );

-- Patients: staff can read/write; patients can read own
create policy "patients_staff_all" on public.patients
  for all using (
    exists (select 1 from public.users where id = auth.uid() and role in ('doctor','secretary'))
  );
create policy "patients_self_read" on public.patients
  for select using (user_id = auth.uid());

-- Appointments: staff can read/write; patients can read own
create policy "appointments_staff_all" on public.appointments
  for all using (
    exists (select 1 from public.users where id = auth.uid() and role in ('doctor','secretary'))
  );
create policy "appointments_patient_read" on public.appointments
  for select using (
    patient_id in (select id from public.patients where user_id = auth.uid())
  );

-- Dental records: staff can read/write; patients can read own
create policy "dental_records_staff_all" on public.dental_records
  for all using (
    exists (select 1 from public.users where id = auth.uid() and role in ('doctor','secretary'))
  );
create policy "dental_records_patient_read" on public.dental_records
  for select using (
    patient_id in (select id from public.patients where user_id = auth.uid())
  );

-- Billing: staff can read/write; patients can read own
create policy "billing_staff_all" on public.billing
  for all using (
    exists (select 1 from public.users where id = auth.uid() and role in ('doctor','secretary'))
  );
create policy "billing_patient_read" on public.billing
  for select using (
    patient_id in (select id from public.patients where user_id = auth.uid())
  );

-- ============================================================
-- Functions & Triggers
-- ============================================================
-- Auto-create public.users row on signup
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.users (id, full_name, phone, role)
  values (
    new.id,
    new.raw_user_meta_data->>'full_name',
    new.raw_user_meta_data->>'phone',
    coalesce(new.raw_user_meta_data->>'role', 'patient')
  );
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Update updated_at on patients
create or replace function public.update_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger patients_updated_at
  before update on public.patients
  for each row execute function public.update_updated_at();
