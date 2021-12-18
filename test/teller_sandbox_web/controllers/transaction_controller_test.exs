defmodule TellerSandboxWeb.TransactionControllerTest do
  use TellerSandboxWeb.ConnCase, async: true

  describe "get transactions" do

    test "transactions for account id not found", %{conn: conn} do

      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("user_12345:")}")
        |> get(Routes.transaction_path(conn, :get_transactions, "acc_12345"), %{"account_id" => "acc_12345"})

      assert response.status == 404
      assert response.resp_body == "Not found"
    end

    test "transactions for account id found", %{conn: conn} do

      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("user_12345:")}")
        |> get(Routes.transaction_path(conn, :get_transactions, "acc_78aae6a7fa0bfb67a00a"),
            %{"account_id" => "acc_78aae6a7fa0bfb67a00a"})

      decoded = Jason.decode!(response.resp_body)
      assert length(decoded) == 90

      trans_0=Enum.at(decoded, 0)
      trans_1=Enum.at(decoded, 1)
      assert Decimal.sub(Decimal.new(trans_1["running_balance"]), Decimal.negate(trans_1["amount"])) == Decimal.new(trans_0["running_balance"])
    end
  end

end
