defmodule ConnectDanceWeb.Api.V1.EventController do
  use ConnectDanceWeb, :controller

  alias ConnectDance.DanceEvents
  alias ConnectDance.DanceEvents.Event

  action_fallback ConnectDanceWeb.FallbackController

  def index(conn, _params) do
    events = DanceEvents.list_events()
    render(conn, :index, events: events)
  end

  def create(conn, %{"event" => event_params}) do
    with {:ok, %Event{} = event} <- DanceEvents.create_event(event_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/events/#{event}")
      |> render(:show, event: event)
    end
  end

  def show(conn, %{"id" => id}) do
    event = DanceEvents.get_event!(id)
    render(conn, :show, event: event)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = DanceEvents.get_event!(id)

    with {:ok, %Event{} = event} <- DanceEvents.update_event(event, event_params) do
      render(conn, :show, event: event)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = DanceEvents.get_event!(id)

    with {:ok, %Event{}} <- DanceEvents.delete_event(event) do
      send_resp(conn, :no_content, "")
    end
  end
end
