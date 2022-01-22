defmodule TellerSandboxWeb.AccountControllerTest do
  use TellerSandboxWeb.ConnCase, async: true

  describe "get accounts" do
    test "get single account", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("user_12345:")}")
        |> get(Routes.account_path(conn, :get_accounts))
        |> json_response(200)

      assert response == [
               %{
                 "currency" => "USD",
                 "enrollment_id" => "enr_rpr3fxwyfbvw3m2edw3r",
                 "id" => "acc_78aae6a7fa0bfb67a00a",
                 "institution" => %{"id" => "chase", "name" => "Chase"},
                 "last_four" => "6420",
                 "links" => %{
                   "balances" =>
                     "http://localhost:4000/accounts/acc_78aae6a7fa0bfb67a00a/balances",
                   "details" => "http://localhost:4000/accounts/acc_78aae6a7fa0bfb67a00a/details",
                   "self" => "http://localhost:4000/accounts/acc_78aae6a7fa0bfb67a00a",
                   "transactions" =>
                     "http://localhost:4000/accounts/acc_78aae6a7fa0bfb67a00a/transactions"
                 },
                 "name" => "Donald Trump",
                 "subtype" => "checking",
                 "type" => "depository"
               }
             ]
    end

    test "get multiple account", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("user_multiple_12345:")}")
        |> get(Routes.account_path(conn, :get_accounts))
        |> json_response(200)

      assert response == [
               %{
                 "currency" => "USD",
                 "enrollment_id" => "enr_c2lfz7sbpqbmsumxoqen",
                 "id" => "acc_81d6181cbdde8b36bcd1",
                 "institution" => %{"id" => "capital_one", "name" => "Capital One"},
                 "last_four" => "5734",
                 "links" => %{
                   "balances" =>
                     "http://localhost:4000/accounts/acc_81d6181cbdde8b36bcd1/balances",
                   "details" => "http://localhost:4000/accounts/acc_81d6181cbdde8b36bcd1/details",
                   "self" => "http://localhost:4000/accounts/acc_81d6181cbdde8b36bcd1",
                   "transactions" =>
                     "http://localhost:4000/accounts/acc_81d6181cbdde8b36bcd1/transactions"
                 },
                 "name" => "Barack Obama",
                 "subtype" => "checking",
                 "type" => "depository"
               },
               %{
                 "currency" => "USD",
                 "enrollment_id" => "enr_wdqonnf3puxdsyb25zw7",
                 "id" => "acc_4302fd48d23cca4577d3",
                 "institution" => %{"id" => "citibank", "name" => "Citibank"},
                 "last_four" => "4163",
                 "links" => %{
                   "balances" =>
                     "http://localhost:4000/accounts/acc_4302fd48d23cca4577d3/balances",
                   "details" => "http://localhost:4000/accounts/acc_4302fd48d23cca4577d3/details",
                   "self" => "http://localhost:4000/accounts/acc_4302fd48d23cca4577d3",
                   "transactions" =>
                     "http://localhost:4000/accounts/acc_4302fd48d23cca4577d3/transactions"
                 },
                 "name" => "Jimmy Carter",
                 "subtype" => "checking",
                 "type" => "depository"
               },
               %{
                 "currency" => "USD",
                 "enrollment_id" => "enr_vj4akvampqzwusuxcmla",
                 "id" => "acc_5c4074cf6deb47f5b6af",
                 "institution" => %{"id" => "citibank", "name" => "Citibank"},
                 "last_four" => "6748",
                 "links" => %{
                   "balances" =>
                     "http://localhost:4000/accounts/acc_5c4074cf6deb47f5b6af/balances",
                   "details" => "http://localhost:4000/accounts/acc_5c4074cf6deb47f5b6af/details",
                   "self" => "http://localhost:4000/accounts/acc_5c4074cf6deb47f5b6af",
                   "transactions" =>
                     "http://localhost:4000/accounts/acc_5c4074cf6deb47f5b6af/transactions"
                 },
                 "name" => "George W. Bush",
                 "subtype" => "checking",
                 "type" => "depository"
               }
             ]
    end
  end

  describe "get account id" do
    test "return account id", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("user_12345:")}")
        |> get(
          Routes.account_path(conn, :get_account_id, "acc_78aae6a7fa0bfb67a00a"),
          %{"account_id" => "acc_78aae6a7fa0bfb67a00a"}
        )
        |> json_response(200)

      assert response ==
               [
                 %{
                   "currency" => "USD",
                   "enrollment_id" => "enr_rpr3fxwyfbvw3m2edw3r",
                   "id" => "acc_78aae6a7fa0bfb67a00a",
                   "institution" => %{"id" => "chase", "name" => "Chase"},
                   "last_four" => "6420",
                   "links" => %{
                     "balances" =>
                       "http://localhost:4000/accounts/acc_78aae6a7fa0bfb67a00a/balances",
                     "details" =>
                       "http://localhost:4000/accounts/acc_78aae6a7fa0bfb67a00a/details",
                     "self" => "http://localhost:4000/accounts/acc_78aae6a7fa0bfb67a00a",
                     "transactions" =>
                       "http://localhost:4000/accounts/acc_78aae6a7fa0bfb67a00a/transactions"
                   },
                   "name" => "Donald Trump",
                   "subtype" => "checking",
                   "type" => "depository"
                 }
               ]
    end

    test "account id not found", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("user_12345:")}")
        |> get(Routes.account_path(conn, :get_account_id, "acc_12345"), %{
          "account_id" => "acc_12345"
        })

      assert response.status == 404
      assert response.resp_body == "Not found"
    end
  end

  describe "get account details" do
    test "get details of account id", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("user_12345:")}")
        |> get(
          Routes.account_path(conn, :get_account_details, "acc_78aae6a7fa0bfb67a00a"),
          %{"account_id" => "acc_78aae6a7fa0bfb67a00a"}
        )
        |> json_response(200)

      assert response == [
               %{
                 "account_id" => "acc_78aae6a7fa0bfb67a00a",
                 "account_number" => "44156420",
                 "links" => %{
                   "account" => "http://localhost:4000/accounts/acc_78aae6a7fa0bfb67a00a",
                   "self" => "http://localhost:4000/accounts/acc_78aae6a7fa0bfb67a00a/details"
                 },
                 "routing_numbers" => %{"ach" => "60078927"}
               }
             ]
    end

    test "details of account id not found", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("user_12345:")}")
        |> get(Routes.account_path(conn, :get_account_details, "acc_12345"), %{
          "account_id" => "acc_12345"
        })

      assert response.status == 404
      assert response.resp_body == "Not found"
    end
  end

  describe "get account balances" do
    test "get balances of account id", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("user_12345:")}")
        |> get(
          Routes.account_path(conn, :get_account_balances, "acc_78aae6a7fa0bfb67a00a"),
          %{"account_id" => "acc_78aae6a7fa0bfb67a00a"}
        )
        |> json_response(200)

      assert response ==
               [
                 %{
                   "account_id" => "acc_78aae6a7fa0bfb67a00a",
                   "available" => "44156",
                   "ledger" => "44156",
                   "links" => %{
                     "account" => "http://localhost:4000/accounts/acc_78aae6a7fa0bfb67a00a",
                     "self" => "http://localhost:4000/accounts/acc_78aae6a7fa0bfb67a00a/balances"
                   }
                 }
               ]
    end

    test "balances of account id not found", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("user_12345:")}")
        |> get(Routes.account_path(conn, :get_account_balances, "acc_12345"), %{
          "account_id" => "acc_12345"
        })

      assert response.status == 404
      assert response.resp_body == "Not found"
    end
  end
end
