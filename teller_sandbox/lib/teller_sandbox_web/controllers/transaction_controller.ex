defmodule TellerSanbox.Controllers.TransactionController do
  use TellerSanboxWeb, :controller

  def get_transactions(conn, %{"account_id" => account_id}) do
    with accounts <- Accounts.from_token(conn.assigns.token, "accounts") do


    end
  end

end
