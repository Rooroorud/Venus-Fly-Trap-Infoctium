create table if not exists public.game_saves (
    user_id uuid primary key references auth.users (id) on delete cascade,
    saves jsonb not null default '{}'::jsonb,
    updated_at timestamptz not null default now()
);

alter table public.game_saves enable row level security;

drop policy if exists "Users can read their own game saves" on public.game_saves;
create policy "Users can read their own game saves"
    on public.game_saves
    for select
    to authenticated
    using ((select auth.uid()) = user_id);

drop policy if exists "Users can create their own game saves" on public.game_saves;
create policy "Users can create their own game saves"
    on public.game_saves
    for insert
    to authenticated
    with check ((select auth.uid()) = user_id);

drop policy if exists "Users can update their own game saves" on public.game_saves;
create policy "Users can update their own game saves"
    on public.game_saves
    for update
    to authenticated
    using ((select auth.uid()) = user_id)
    with check ((select auth.uid()) = user_id);

drop policy if exists "Users can delete their own game saves" on public.game_saves;
create policy "Users can delete their own game saves"
    on public.game_saves
    for delete
    to authenticated
    using ((select auth.uid()) = user_id);

grant select, insert, update, delete on public.game_saves to authenticated;
