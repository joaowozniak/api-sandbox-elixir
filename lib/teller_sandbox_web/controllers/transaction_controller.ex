defmodule TellerSandboxWeb.TransactionController do
  use TellerSandboxWeb, :controller
  alias TellerSandbox.Contexts.{Accounts, Transactions}

  def get_transactions(conn, %{"account_id" => account_id}) do
    with accounts <- Accounts.from_token(conn.assigns.token, true),
      account <- Accounts.get_by_id(accounts, account_id) do

        cond do
          account ->
            transactions = Transactions.generate_transactions(account)
            conn |> json(transactions)

          true ->
            conn |> send_resp(404, "Not found")
        end
    end
  end


  def get_transaction_id(conn, %{"account_id" => account_id, "transaction_id" => transaction_id}) do
    with accounts <- Accounts.from_token(conn.assigns.token, true),
      account <- Accounts.get_by_id(accounts, account_id) do

        cond do
          account ->
            transactions = Transactions.generate_transactions(account)
            transaction = Transactions.get_by_id(transactions, transaction_id)

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
