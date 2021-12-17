defmodule TellerSandboxWeb.Plugs.Authentication do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    with {user, pass} <- Plug.BasicAuth.parse_basic_auth(conn),
        {:valid, _} <- verify_user(user, pass) do

          token = token_from_user(user)

      assign(conn, :token, token)

    else
      _ -> Plug.BasicAuth.request_basic_auth(conn) |> halt()
    end
  end

  defp verify_user(user, password) do
    cond do

      (String.starts_with?(user, "user_") &&
      String.length(user) == 10 &&
      Regex.match?(~r{\A\d*\z}, String.slice(user, 5, 5)) &&
      String.length(password) == 0) ->

        {:valid, true}

      (String.starts_with?(user, "user_multiple") &&
      String.length(user) == 19 &&
      Regex.match?(~r{\A\d*\z}, String.slice(user, 14, 5)) &&
      String.length(password) == 0) ->

        {:valid, true}

      true -> {:not_valid, false}

    end
  end

  defp token_from_user(user) do
    encoded = Base.encode64(user)
    token = "test_" <> encoded
  end

end
