defmodule TellerSandbox.Contexts.Account do

  def from_token(token) do
    IO.puts("here")
    IO.puts(token)
    IO.puts("next")

    %TellerSandbox.Models.Account{
      currency: "abs",
      enrollment_id: "abss",
      account_id: "kak"
    }

  end

end
