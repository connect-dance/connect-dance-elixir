defmodule ConnectDance.DanceEventsTest do
  use ConnectDance.DataCase

  alias ConnectDance.DanceEvents

  describe "events" do
    alias ConnectDance.DanceEvents.Event

    import ConnectDance.DanceEventsFixtures

    @invalid_attrs %{
      name: nil,
      address: nil,
      description: nil,
      ticket_link: nil,
      starts_at: nil,
      ends_at: nil
    }

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert DanceEvents.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert DanceEvents.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      event_type = event_type_fixture()

      valid_attrs = %{
        name: "some name",
        address: "some address",
        description: "some description",
        ticket_link: "some ticket_link",
        starts_at: ~N[2024-10-24 13:15:00],
        ends_at: ~N[2024-10-24 13:15:00],
        event_type_id: event_type.id
      }

      assert {:ok, %Event{} = event} = DanceEvents.create_event(valid_attrs)
      assert event.name == "some name"
      assert event.address == "some address"
      assert event.description == "some description"
      assert event.ticket_link == "some ticket_link"
      assert event.starts_at == ~N[2024-10-24 13:15:00]
      assert event.ends_at == ~N[2024-10-24 13:15:00]
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = DanceEvents.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()

      update_attrs = %{
        name: "some updated name",
        address: "some updated address",
        description: "some updated description",
        ticket_link: "some updated ticket_link",
        starts_at: ~N[2024-10-25 13:15:00],
        ends_at: ~N[2024-10-25 13:15:00]
      }

      assert {:ok, %Event{} = event} = DanceEvents.update_event(event, update_attrs)
      assert event.name == "some updated name"
      assert event.address == "some updated address"
      assert event.description == "some updated description"
      assert event.ticket_link == "some updated ticket_link"
      assert event.starts_at == ~N[2024-10-25 13:15:00]
      assert event.ends_at == ~N[2024-10-25 13:15:00]
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = DanceEvents.update_event(event, @invalid_attrs)
      assert event == DanceEvents.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = DanceEvents.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> DanceEvents.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = DanceEvents.change_event(event)
    end
  end

  describe "event_types" do
    alias ConnectDance.DanceEvents.EventType

    import ConnectDance.DanceEventsFixtures

    @invalid_attrs %{name: nil}

    test "list_event_types/0 returns all event_types" do
      event_type = event_type_fixture()
      assert DanceEvents.list_event_types() == [event_type]
    end

    test "get_event_type!/1 returns the event_type with given id" do
      event_type = event_type_fixture()
      assert DanceEvents.get_event_type!(event_type.id) == event_type
    end

    test "create_event_type/1 with valid data creates a event_type" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %EventType{} = event_type} = DanceEvents.create_event_type(valid_attrs)
      assert event_type.name == "some name"
    end

    test "create_event_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = DanceEvents.create_event_type(@invalid_attrs)
    end

    test "update_event_type/2 with valid data updates the event_type" do
      event_type = event_type_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %EventType{} = event_type} =
               DanceEvents.update_event_type(event_type, update_attrs)

      assert event_type.name == "some updated name"
    end

    test "update_event_type/2 with invalid data returns error changeset" do
      event_type = event_type_fixture()

      assert {:error, %Ecto.Changeset{}} =
               DanceEvents.update_event_type(event_type, @invalid_attrs)

      assert event_type == DanceEvents.get_event_type!(event_type.id)
    end

    test "delete_event_type/1 deletes the event_type" do
      event_type = event_type_fixture()
      assert {:ok, %EventType{}} = DanceEvents.delete_event_type(event_type)
      assert_raise Ecto.NoResultsError, fn -> DanceEvents.get_event_type!(event_type.id) end
    end

    test "change_event_type/1 returns a event_type changeset" do
      event_type = event_type_fixture()
      assert %Ecto.Changeset{} = DanceEvents.change_event_type(event_type)
    end
  end
end
