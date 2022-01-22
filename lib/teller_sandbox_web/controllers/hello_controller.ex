defmodule TellerSandboxWeb.HelloController do
  use TellerSandboxWeb, :controller

  def index(conn, _params) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello.")
  end

  def show(conn, %{"message" => message}) do
    conn
    |> put_resp_content_type("application/json")
    |> json(%{message: message})
  end
end
