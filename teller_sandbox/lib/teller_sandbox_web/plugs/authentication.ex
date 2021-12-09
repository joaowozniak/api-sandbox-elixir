defmodule TellerSandboxWeb.Plugs.Authentication do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    with {user, _} <- Plug.BasicAuth.parse_basic_auth(conn),
      {:ok, _} <- verify_user(user) do
        IO.puts(:ok)
      #%User{} = user <- MyApp.Accounts.find_by_username_and_password(user, pass) do
      assign(conn, :user, user)
    else
      _ -> conn |> Plug.BasicAuth.request_basic_auth() |> halt()
    end
  end

  def verify_user(user) do
    IO.puts(user)
    {:ok, true}
  end

end
