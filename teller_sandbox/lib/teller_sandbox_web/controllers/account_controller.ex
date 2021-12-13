defmodule TellerSandboxWeb.AccountController do
  use TellerSandboxWeb, :controller
  alias TellerSandbox.Contexts.Accounts

  def get_accounts(conn, _params) do

    accounts = Accounts.from_token(conn.assigns.token, "accounts")

    conn |> json(accounts)
  end

  def get_account_id(conn, %{"account_id" => account_id}) do
    with accounts <- Accounts.from_token(conn.assigns.token, "accounts") do
      account = Enum.find(accounts, fn acc -> acc.id == account_id end)

      if account do
        conn |> json(account)
      else
        conn |> send_resp(404, "Not found")
      end
    end
  end

  #TODO!! check for non existing acc ids
  def get_account_details(conn, %{"account_id" => account_id}) do
    with accounts <- Accounts.from_token(conn.assigns.token, "details") do

      account = Enum.find(accounts, fn acc -> acc.id == account_id  end)
      #TODO improve later
      account = Enum.map([account], &(with {k, v} <- Map.pop(&1, :id), do: Map.put(v, :account_id, k)))

      if account do
        conn |> json(account)
      else
        conn |> send_resp(404, "Not found")
      end

    end
  end


  #TODO!! check for non existing acc ids
  def get_account_balances(conn, %{"account_id" => account_id}) do
    with accounts <- Accounts.from_token(conn.assigns.token, "balances") do

      account = Enum.find(accounts, fn acc -> acc.id == account_id  end)
      #TODO improve later
      account = Enum.map([account], &(with {k, v} <- Map.pop(&1, :id), do: Map.put(v, :account_id, k)))

      if account do
        conn |> json(account)
      else
        conn |> send_resp(404, "Not found")
      end

    end
  end



end
