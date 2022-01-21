defmodule TellerSandboxWeb.AccountController do
  use TellerSandboxWeb, :controller
  alias TellerSandbox.Contexts.Accounts

  def get_accounts(conn, _params) do
    conn |> json(Accounts.all(conn.assigns.token))
  end

  def get_account_id(conn, %{"account_id" => account_id}) do
    with account <- Accounts.show(conn.assigns.token, account_id) do
      cond do
        account ->
          conn |> json(account)

        true ->
          conn |> send_resp(404, "Not found")
      end
    end
  end

  def get_account_details(conn, %{"account_id" => account_id}) do
    with accounts <- Accounts.from_token(conn.assigns.token, "details"),
         account <- Enum.find(accounts, fn acc -> acc.account_id == account_id end) do
      cond do
        account ->
          conn |> json(account)

        true ->
          conn |> send_resp(404, "Not found")
      end
    end
  end

  def get_account_balances(conn, %{"account_id" => account_id}) do
    with accounts <- Accounts.from_token(conn.assigns.token, "balances"),
         account <- Enum.find(accounts, fn acc -> acc.account_id == account_id end) do
      cond do
        account ->
          conn |> json(account)

        true ->
          conn |> send_resp(404, "Not found")
      end
    end
  end
end
