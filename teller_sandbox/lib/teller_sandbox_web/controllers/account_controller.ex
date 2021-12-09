defmodule TellerSandboxWeb.AccountController do
  use TellerSandboxWeb, :controller
  alias TellerSandbox.Contexts.Account

  def index(conn, _params) do

    accounts = Account.from_token("conn.assigns.port")

    conn
    |>json(accounts)

  end

end
