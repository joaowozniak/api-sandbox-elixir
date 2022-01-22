defmodule TellerSandboxWeb.TransactionController do
  use TellerSandboxWeb, :controller
  alias TellerSandbox.Contexts.{Accounts, Transactions}

  def get_transactions(conn, %{"account_id" => account_id}) do
    with account <- Accounts.balances(conn.assigns.token, account_id) do
      cond do
        account ->
          transactions = Transactions.generate_transactions(Enum.at(account, 0))
          conn |> json(transactions)

        true ->
          conn |> send_resp(404, "Not found")
      end
    end
  end

  def get_transaction_id(conn, %{"account_id" => account_id, "transaction_id" => transaction_id}) do
    with account <- Accounts.balances(conn.assigns.token, account_id) do
      cond do
        account ->
          transactions = Transactions.generate_transactions(Enum.at(account, 0))
          transaction = [Transactions.show(transactions, transaction_id)]

          cond do
            transaction ->
              conn |> json(transaction)

            true ->
              conn |> send_resp(404, "Not found")
          end

        true ->
          conn |> send_resp(404, "Not found")
      end
    end
  end
end
