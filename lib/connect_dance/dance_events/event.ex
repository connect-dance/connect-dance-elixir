defmodule ConnectDance.DanceEvents.Event do
  use Ecto.Schema
  import Ecto.Changeset

  alias ConnectDance.DanceEvents.EventType

  schema "events" do
    field :name, :string
    field :description, :string
    field :address, :string
    field :ticket_link, :string
    field :starts_at, :naive_datetime
    field :ends_at, :naive_datetime

    field :location, Geo.PostGIS.Geometry

    # Associations
    belongs_to :event_type, EventType

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [
      :name,
      :description,
      :address,
      :ticket_link,
      :starts_at,
      :ends_at,
      :location,
      :event_type_id
    ])
    |> validate_required([
      :name,
      :address,
      :starts_at,
      :ends_at,
      :event_type_id
    ])
    |> foreign_key_constraint(:event_type_id)
  end
end
