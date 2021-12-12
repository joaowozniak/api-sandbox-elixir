defmodule TellerSandboxWeb.AccountController do
  use TellerSandboxWeb, :controller
  alias TellerSandbox.Contexts.Accounts

  def get_accounts(conn, _params) do
    accounts = Accounts.from_token(conn.assigns.token)

    conn |> json(accounts)
  end

  def get_account_id(conn, %{"account_id" => account_id}) do
    with accounts <- Accounts.from_token(conn.assigns.token) do
      account = Enum.find(accounts, fn acc -> acc.id == account_id end)

      if account do
        conn |> json(account)
      else
        conn |> send_resp(404, "Not found")
      end
    end

  end

end
