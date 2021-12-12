defmodule TellerSandbox.Contexts.Accounts do
  alias TellerSandbox.Models.Account
  alias TellerSandbox.Models.AccountLink
  alias TellerSandbox.Contexts.Institutions

  @base_link "http://localhost:4000/accounts/"

  defp get_all_account_names do
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

  defp get_pseudo_random_from_token(token) do
    :sha256 |> :crypto.hash(token) |> :erlang.phash2()
  end

  defp generate_account(token) do
    currency = "USD"
    enrollment_id = "enr_" <> (:sha256 |> :crypto.hash(token) |> Base.encode32 |> String.downcase() |> String.slice(20,20))
    id = "acc_" <> (:sha256 |> :crypto.hash(token) |> Base.encode16 |> String.downcase() |> String.slice(0,20))
    account_number = get_pseudo_random_from_token(token)
    institution = Institutions.from_token(token)
    last_four = String.slice(Integer.to_string(account_number), -4, 4)
    links = %AccountLink{
        balances: @base_link <> "#{id}/balances",
        details: @base_link <> "#{id}/details",
        self: @base_link <> "#{id}",
        transactions: @base_link <> "#{id}/transactions"
      }
    name = Enum.at(get_all_account_names(), Integer.mod(get_pseudo_random_from_token(token), length(get_all_account_names())))
    subtype = "checking"
    type = "depository"

    %Account{
      currency: currency,
      enrollment_id: enrollment_id,
      id: id,
      institution: institution,
      last_four: last_four,
      links: links,
      name: name,
      subtype: subtype,
      type: type
    }
  end

  def from_token(token) do

    acc_one = generate_account(token)

    cond do
      (String.length(token) == 33) ->

        acc_two = generate_account(token)
        [acc_one, acc_two]

      (String.length(token) == 21) -> [acc_one]

      true -> {:not_valid, false}
    end
  end

end
