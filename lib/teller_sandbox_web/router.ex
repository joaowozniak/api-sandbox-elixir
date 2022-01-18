defmodule TellerSandboxWeb.Router do
  use TellerSandboxWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug TellerSandboxWeb.Plugs.Authentication
  end

  scope "/", TellerSandboxWeb do
    pipe_through :api

    get "/", HelloController, :index
    get "/accounts", AccountController, :get_accounts
    get "/accounts/:account_id", AccountController, :get_account_id
    get "/accounts/:account_id/details", AccountController, :get_account_details
    get "/accounts/:account_id/balances", AccountController, :get_account_balances
    get "/accounts/:account_id/transactions", TransactionController, :get_transactions

    get "/accounts/:account_id/transactions/:transaction_id",
        TransactionController,
        :get_transaction_id
  end

  # Other scopes may use custom stacks.
  # scope "/api", TellerSandboxWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  '''
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router
  
    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: TellerSandboxWeb.Telemetry
    end
  end
  '''

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  '''
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser
  
      #forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
  '''
end
