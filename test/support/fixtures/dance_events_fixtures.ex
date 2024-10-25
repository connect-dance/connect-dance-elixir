defmodule ConnectDance.DanceEventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ConnectDance.DanceEvents` context.
  """

 @doc """
  Generate a unique event name.
  """
  def unique_event_name do
    "Event #{System.unique_integer([:positive])}"
  end

  @doc """
  Generate a unique event type name.
  """
  def unique_event_type_name do
    "EventType #{System.unique_integer([:positive])}"
  end
  
  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    event_type = event_type_fixture()
    {:ok, event} =
      attrs
      |> Enum.into(%{
        name: unique_event_name(),
        description: "some description",
        address: "some address",
        ticket_link: "https://strangfeld.io",
        starts_at: ~N[2024-10-24 13:00:00],
        ends_at: ~N[2024-10-24 13:15:00],
        location: %Geo.Point{coordinates: {30, -90}, srid: 4326},
        event_type_id: event_type.id
      })
      |> ConnectDance.DanceEvents.create_event()

    event
  end

  @doc """
  Generate a event_type.
  """
  def event_type_fixture(attrs \\ %{}) do
    {:ok, event_type} =
      attrs
      |> Enum.into(%{
        name: unique_event_type_name()
      })
      |> ConnectDance.DanceEvents.create_event_type()

    event_type
  end
end
