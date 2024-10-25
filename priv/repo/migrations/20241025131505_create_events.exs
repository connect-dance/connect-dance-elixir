defmodule ConnectDance.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:event_types) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end

    create table(:events) do
      add :name, :string
      add :description, :string
      add :address, :string
      add :ticket_link, :string
      add :starts_at, :naive_datetime
      add :ends_at, :naive_datetime

      add :location, :geography

      add :event_type_id, references(:event_types, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end
  end
end
