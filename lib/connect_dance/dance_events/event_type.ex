defmodule ConnectDance.DanceEvents.EventType do
  use Ecto.Schema
  import Ecto.Changeset

  alias ConnectDance.DanceEvents.Event

  schema "event_types" do
    field :name, :string

    # Associations
    has_many :events, Event

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event_type, attrs) do
    event_type
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
