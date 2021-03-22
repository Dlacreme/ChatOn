Chaton.Repo.insert!(%Chaton.Auth.UserRole{
  id: "guest",
  label: "Guest"
})

Chaton.Repo.insert!(%Chaton.Auth.UserRole{
  id: "user",
  label: "User"
})

{:ok, _} = Chaton.Auth.add_admin("admin@chaton.com", "toto4242")
