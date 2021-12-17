defmodule TellerSandboxWeb.AccountControllerTest do
  use TellerSandboxWeb.ConnCase, async: true

  describe "get accounts" do

    test "get single account", %{conn: conn} do

      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("user_12345:")}")
        |> get(Routes.account_path(conn, :get_accounts))
        |> json_response(200)

      assert response ==
        [%{
            "currency"=>"USD",
            "enrollment_id"=>"enr_npp6qwkcjzfpqx2z2wy6",
            "id"=>"acc_78aae6a7fa0bfb67a00a",
            "institution"=> %{
              "id"=>"capital_one",
              "name"=>"Capital One"
            },
            "last_four"=>"2314",
            "links"=> %{
              "balances"=>"http://localhost:4000/accounts/acc_78aae6a7fa0bfb67a00a/balances",
              "details"=>"http://localhost:4000/accounts/acc_78aae6a7fa0bfb67a00a/details",
              "self"=>"http://localhost:4000/accounts/acc_78aae6a7fa0bfb67a00a",
              "transactions"=>"http://localhost:4000/accounts/acc_78aae6a7fa0bfb67a00a/transactions"
            },
            "name"=>"Ronald Reagan",
            "subtype"=>"checking",
            "type"=>"depository"
          }]
    end

    test "get multiple account", %{conn: conn} do

      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("user_multiple_12345:")}")
        |> get(Routes.account_path(conn, :get_accounts))
        |> json_response(200)

        assert response ==
          [%{
            "currency"=>"USD",
            "enrollment_id"=>"enr_fb4jwjelxvkaewnxvrcy",
            "id"=>"acc_360d80c5a300af22c2b7",
            "institution"=> %{
              "id"=>"wells_fargo",
              "name"=>"Wells Fargo"
            },
            "last_four"=>"9697",
            "links"=> %{
              "balances"=>"http://localhost:4000/accounts/acc_360d80c5a300af22c2b7/balances",
              "details"=>"http://localhost:4000/accounts/acc_360d80c5a300af22c2b7/details",
              "self"=>"http://localhost:4000/accounts/acc_360d80c5a300af22c2b7",
              "transactions"=>"http://localhost:4000/accounts/acc_360d80c5a300af22c2b7/transactions"
            },
            "name"=>"Barack Obama",
            "subtype"=>"checking",
            "type"=>"depository"
        },
        %{
            "currency"=>"USD",
            "enrollment_id"=>"enr_qzivvxx3kwjsrqb4u3wp",
            "id"=>"acc_30fd70176e37a8cec398",
            "institution"=> %{
              "id"=>"bank_of_america",
              "name"=>"Bank of America"
            },
            "last_four"=>"4896",
            "links"=> %{
              "balances"=>"http://localhost:4000/accounts/acc_30fd70176e37a8cec398/balances",
              "details"=>"http://localhost:4000/accounts/acc_30fd70176e37a8cec398/details",
              "self"=>"http://localhost:4000/accounts/acc_30fd70176e37a8cec398",
              "transactions"=>"http://localhost:4000/accounts/acc_30fd70176e37a8cec398/transactions"
            },
            "name"=>"George W. Bush",
            "subtype"=>"checking",
            "type"=>"depository"
        }]
    end
  end

  describe "get account id" do

    test "return account id", %{conn: conn} do

      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("user_12345:")}")
        |> get(Routes.account_path(conn, :get_account_id, "acc_78aae6a7fa0bfb67a00a"),
            %{"account_id" => "acc_78aae6a7fa0bfb67a00a"})
        |> json_response(200)

        assert response ==
          %{
            "currency"=>"USD",
            "enrollment_id"=>"enr_npp6qwkcjzfpqx2z2wy6",
            "id"=>"acc_78aae6a7fa0bfb67a00a",
            "institution"=> %{
              "id"=>"capital_one",
              "name"=>"Capital One"
            },
            "last_four"=>"2314",
            "links"=> %{
              "balances"=>"http://localhost:4000/accounts/acc_78aae6a7fa0bfb67a00a/balances",
              "details"=>"http://localhost:4000/accounts/acc_78aae6a7fa0bfb67a00a/details",
              "self"=>"http://localhost:4000/accounts/acc_78aae6a7fa0bfb67a00a",
              "transactions"=>"http://localhost:4000/accounts/acc_78aae6a7fa0bfb67a00a/transactions"
            },
            "name"=>"Ronald Reagan",
            "subtype"=>"checking",
            "type"=>"depository"
          }
    end

    test "account id not found", %{conn: conn} do

      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("user_12345:")}")
        |> get(Routes.account_path(conn, :get_account_id, "acc_12345"), %{"account_id" => "acc_12345"})

        assert response.status == 404
        assert response.resp_body == "Not found"
    end
  end

  describe "get account details" do

    test "get details of account id", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("user_12345:")}")
        |> get(Routes.account_path(conn, :get_account_details, "acc_78aae6a7fa0bfb67a00a"),
            %{"account_id" => "acc_78aae6a7fa0bfb67a00a"})
        |> json_response(200)

      assert response ==
        %{
          "account_id"=>"acc_78aae6a7fa0bfb67a00a",
          "account_number"=>"11082314",
          "links"=> %{
             "account"=>"http://localhost:4000/accounts/acc_78aae6a7fa0bfb67a00a",
             "self"=>"http://localhost:4000/accounts/acc_78aae6a7fa0bfb67a00a/details"
          },
          "routing_numbers"=> %{
             "ach"=>"47983230"
          }
       }
    end

    test "details of account id not found", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("user_12345:")}")
        |> get(Routes.account_path(conn, :get_account_details, "acc_12345"), %{"account_id" => "acc_12345"})

      assert response.status == 404
      assert response.resp_body == "Not found"
    end
  end

  describe "get account balances" do

    test "get balances of account id", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("user_12345:")}")
        |> get(Routes.account_path(conn, :get_account_balances, "acc_78aae6a7fa0bfb67a00a"),
            %{"account_id" => "acc_78aae6a7fa0bfb67a00a"})
        |> json_response(200)

      assert response ==
        %{
          "account_id"=>"acc_78aae6a7fa0bfb67a00a",
          "available"=>"11082",
          "ledger"=>"11082",
          "links"=> %{
             "account"=>"http://localhost:4000/accounts/acc_78aae6a7fa0bfb67a00a",
             "self"=>"http://localhost:4000/accounts/acc_78aae6a7fa0bfb67a00a/balances"
          }
       }
    end

    test "balances of account id not found", %{conn: conn} do
      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("user_12345:")}")
        |> get(Routes.account_path(conn, :get_account_balances, "acc_12345"), %{"account_id" => "acc_12345"})

      assert response.status == 404
      assert response.resp_body == "Not found"
    end
  end
end
