"use client";
export default function SettingsPage() {
  return (
    <div className="mx-auto max-w-7xl space-y-8 px-6 py-6">
      <h1 className="text-xl font-semibold">Настройки</h1>

      <section className="panel p-5">
        <h2 className="mb-3 font-medium">Профиль</h2>
        <div className="grid gap-3 sm:grid-cols-2">
          <div>
            <label className="form-label">Имя</label>
            <input
              className="form-control"
              placeholder="Имя"
            />
          </div>
          <div>
            <label className="form-label">Email</label>
            <input className="form-control" placeholder="Email" />
          </div>
        </div>
        <div className="mt-3">
          <button className="btn btn-primary btn--sm">
            Сохранить
          </button>
        </div>
      </section>

      <section className="panel p-5">
        <h2 className="mb-3 font-medium">Брендинг</h2>
        <div className="flex items-center gap-3">
          <div className="h-12 w-12 rounded-lg border panel-border bg-neutral-900/60" />
          <button className="btn btn-ghost btn--sm">
            Загрузить логотип
          </button>
        </div>
      </section>

      <section className="panel p-5">
        <h2 className="mb-3 font-medium">Тема</h2>
        <p className="text-sm text-muted-foreground">
          Тёмная (по умолчанию).
        </p>
      </section>
    </div>
  );
}

