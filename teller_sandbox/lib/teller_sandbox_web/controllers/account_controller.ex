defmodule TellerSandboxWeb.AccountController do
  use TellerSandboxWeb, :controller
  alias TellerSandbox.Contexts.Account

  def get_accounts(conn, _params) do

    accounts = Account.from_token(conn.assigns.token)

    conn
    |>json(accounts)

  end

end
