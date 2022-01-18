defmodule TellerSandboxWeb.Plugs.Authentication do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    with {user, pass} <- Plug.BasicAuth.parse_basic_auth(conn),
         {:valid, true} <- verify_user(user, pass) do
      token = token_from_user(user)
      assign(conn, :token, token)
    else
      _ -> conn |> Plug.BasicAuth.request_basic_auth() |> unauthorized()
    end
  end

  defp verify_user(user, password) do
    cond do
      String.starts_with?(user, "user_") &&
        String.length(user) == 10 &&
        Regex.match?(~r{\A\d*\z}, String.slice(user, 5, 5)) &&
          String.length(password) == 0 ->
        {:valid, true}

      String.starts_with?(user, "user_multiple_") &&
        String.length(user) == 19 &&
        Regex.match?(~r{\A\d*\z}, String.slice(user, 14, 5)) &&
          String.length(password) == 0 ->
        {:valid, true}

      true ->
        {:valid, false}
    end
  end

  defp token_from_user(user) do
    encoded = Base.encode64(user)
    token = "test_" <> encoded
    token
  end

  defp unauthorized(conn) do
    response =
      Phoenix.json_library().encode_to_iodata!(%{
        error: %{
          message: "Unauthorized 401",
          code: "forbidden"
        }
      })

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, response)
    |> halt()
  end
end
