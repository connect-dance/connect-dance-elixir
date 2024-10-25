defmodule ConnectDanceWeb.Api.V1.EventJSON do
  alias ConnectDance.DanceEvents.Event

  @doc """
  Renders a list of events.
  """
  def index(%{events: events}) do
    %{data: for(event <- events, do: data(event))}
  end

  @doc """
  Renders a single event.
  """
  def show(%{event: event}) do
    %{data: data(event)}
  end

  defp data(%Event{} = event) do
    %{
      id: event.id,
      name: event.name,
      description: event.description,
      address: event.address,
      ticket_link: event.ticket_link,
      starts_at: event.starts_at,
      ends_at: event.ends_at
    }
  end
end
