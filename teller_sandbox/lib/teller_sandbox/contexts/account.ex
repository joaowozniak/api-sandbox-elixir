defmodule TellerSandbox.Contexts.Account do

  @base_link "http://localhost:8000/accounts/"

  def get_all_account_names do
    names = [
        "My Checking",
        "Jimmy Carter",
        "Ronald Reagan",
        "George H. W. Bush",
        "Bill Clinton",
        "George W. Bush",
        "Barack Obama",
        "Donald Trump",
    ]
  end

  def from_token(token) do

    #IO.puts(
    #  token_hash = :sha256 |> :crypto.hash(token) |> Base.encode32 |> String.downcase() |> String.slice(5,15)  )
    currency = "USD"
    enrollment_id = "enr_" <> (:sha256 |> :crypto.hash(token) |> Base.encode32 |> String.downcase() |> String.slice(20,20))
    account_id = "acc_" <> (:sha256 |> :crypto.hash(token) |> Base.encode16 |> String.downcase() |> String.slice(0,20))
    account_number = :sha256 |> :crypto.hash(token) |> :erlang.phash2()
    last_four = String.slice(Integer.to_string(account_number), -4, 4)

    IO.puts(enrollment_id)

    %TellerSandbox.Models.Account{
      currency: currency,
      enrollment_id: enrollment_id,
      account_id: account_id,
      account_number: account_number,
      last_four: last_four

    }

  end
end
