# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ConnectDance.Repo.insert!(%ConnectDance.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ConnectDance.Repo
alias ConnectDance.DanceEvents.EventType

event_types = [
  "Workshop",
  "Festival",
  "Party",
  "Class",
  "WSDC Festival"
]

for name <- event_types do
  %EventType{name: name}
  |> EventType.changeset(%{})
  |> Repo.insert!(on_conflict: :nothing)
end
