defmodule TellerSandboxWeb.TransactionController do
  use TellerSandboxWeb, :controller
  alias TellerSandbox.Contexts.{Accounts, Transactions}

  def get_transactions(conn, %{"account_id" => account_id}) do
    with accounts <- Accounts.from_token(conn.assigns.token, true) do
      account = Enum.find(accounts, fn acc -> acc.id == account_id end)

      if account do
        transactions = Transactions.generate_transactions(account)

        conn
        |> json(transactions)
      else
        conn |> send_resp(404, "Not found")
      end

    end
  end


end
