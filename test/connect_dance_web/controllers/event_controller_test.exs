defmodule ConnectDanceWeb.EventControllerTest do
  use ConnectDanceWeb.ConnCase

  import ConnectDance.DanceEventsFixtures

  alias ConnectDance.DanceEvents.Event

  @create_attrs %{
    name: "some name",
    address: "some address",
    description: "some description",
    ticket_link: "some ticket_link",
    starts_at: ~N[2024-10-24 17:00:00],
    ends_at: ~N[2024-10-24 17:00:00]
  }
  @update_attrs %{
    name: "some updated name",
    address: "some updated address",
    description: "some updated description",
    ticket_link: "some updated ticket_link",
    starts_at: ~N[2024-10-25 17:00:00],
    ends_at: ~N[2024-10-25 17:00:00]
  }
  @invalid_attrs %{
    name: nil,
    address: nil,
    description: nil,
    ticket_link: nil,
    starts_at: nil,
    ends_at: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = get(conn, ~p"/api/events")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create event" do
    test "renders event when data is valid", %{conn: conn} do
      event_type = event_type_fixture()
      create_attrs = Map.put(@create_attrs, :event_type_id, event_type.id)

      conn = post(conn, ~p"/api/events", event: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/events/#{id}")

      assert %{
               "id" => ^id,
               "address" => "some address",
               "description" => "some description",
               "ends_at" => "2024-10-24T17:00:00",
               "name" => "some name",
               "starts_at" => "2024-10-24T17:00:00",
               "ticket_link" => "some ticket_link"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/events", event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update event" do
    setup [:create_event]

    test "renders event when data is valid", %{conn: conn, event: %Event{id: id} = event} do
      conn = put(conn, ~p"/api/events/#{event}", event: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/events/#{id}")

      assert %{
               "id" => ^id,
               "address" => "some updated address",
               "description" => "some updated description",
               "ends_at" => "2024-10-25T17:00:00",
               "name" => "some updated name",
               "starts_at" => "2024-10-25T17:00:00",
               "ticket_link" => "some updated ticket_link"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put(conn, ~p"/api/events/#{event}", event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete(conn, ~p"/api/events/#{event}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/events/#{event}")
      end
    end
  end

  defp create_event(_) do
    event = event_fixture()
    %{event: event}
  end
end
