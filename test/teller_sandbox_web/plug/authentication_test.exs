defmodule TellerSandboxWeb.AuthenticationTest do
  use TellerSandboxWeb.ConnCase, async: true

  describe "authentication" do
    test "username permited" do

      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("user_12345:")}")
        |> TellerSandboxWeb.Plugs.Authentication.call(%{})

        assert response.assigns.token == "test_dXNlcl8xMjM0NQ=="
    end

    test "username not permited" do

      response =
        build_conn()
        |> put_req_header("authorization", "Basic #{Base.url_encode64("user_1234:")}")
        |> TellerSandboxWeb.Plugs.Authentication.call(%{})

        assert response.resp_body == "Unauthorized"
    end
  end
end
