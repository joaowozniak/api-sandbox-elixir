defmodule TellerSandboxWeb.AccountController do
  use TellerSandboxWeb, :controller
  alias TellerSandbox.Contexts.Accounts

  def get_accounts(conn, _params) do

    accounts = Accounts.from_token(conn.assigns.token)

    conn
    |>json(accounts)

  end

end
