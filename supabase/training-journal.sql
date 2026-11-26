begin;
create table public.xau_training_journal (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  summary text not null check (char_length(summary) between 1 and 500),
  thesis text not null default '' check (char_length(thesis) <= 400),
  reflection text not null default '' check (char_length(reflection) <= 400),
  created_at timestamptz not null default now()
);
alter table public.xau_training_journal enable row level security;
revoke all on public.xau_training_journal from public, anon, authenticated;
grant select, insert, update on public.xau_training_journal to authenticated;
create policy journal_read_own on public.xau_training_journal for select to authenticated using ((select auth.uid()) = user_id);
create policy journal_insert_own on public.xau_training_journal for insert to authenticated with check ((select auth.uid()) = user_id);
create policy journal_update_own on public.xau_training_journal for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create index xau_training_journal_owner_recent on public.xau_training_journal (user_id, created_at desc);
commit;
