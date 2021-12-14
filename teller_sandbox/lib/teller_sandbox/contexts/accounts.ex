defmodule TellerSandbox.Contexts.Accounts do
  alias TellerSandbox.Models.{Account, AccountLink}
  alias TellerSandbox.Contexts.{Institutions, RoutingNumbers}

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
    account_number = get_pseudo_random_from_token(token) |> Integer.to_string()
    institution = Institutions.from_token(token)
    last_four = account_number |> String.slice(-4, 4)
    links = %AccountLink{
        balances: @base_link <> "#{id}/balances",
        details: @base_link <> "#{id}/details",
        self: @base_link <> "#{id}",
        transactions: @base_link <> "#{id}/transactions"
      }
    routing_numbers = RoutingNumbers.from_institution(institution.id)
    name = Enum.at(get_all_account_names(), Integer.mod(get_pseudo_random_from_token(token), length(get_all_account_names())))
    subtype = "checking"
    type = "depository"
    available = get_pseudo_random_from_token(String.reverse(token))/1 |> Float.to_string(decimals: 2) |> String.slice(4,8)

    acc = %Account{
      currency: currency,
      enrollment_id: enrollment_id,
      id: id,
      account_number: account_number,
      institution: institution,
      last_four: last_four,
      links: links,
      routing_numbers: routing_numbers,
      name: name,
      subtype: subtype,
      type: type,
      available: available,
      ledger: available
    }
  end

  def show_account_attributes(account, type) do
    cond do

      type == "accounts" ->
        keys = [:currency, :enrollment_id, :id, :institution, :last_four, :links, :name, :subtype, :type]
        account = Map.take(account, keys)

      type == "details" ->
        keys = [:id, :account_number, :links, :routing_numbers]
        account = Map.take(account,keys)

      type == "balances" ->
        keys = [:id, :available, :ledger, :links]
        account = Map.take(account, keys)

      true -> account
    end
  end


  def from_token(token, type) do
    acc_one = generate_account(token)

    cond do
      (String.length(token) == 33) ->

        #TODO improve generating pseudo random number of accounts of user_multiple
        token_2 = String.reverse(token)
        acc_two = generate_account(token_2)
        [show_account_attributes(acc_one, type), show_account_attributes(acc_two, type)]

      (String.length(token) == 21) -> [show_account_attributes(acc_one, type)]
    end
  end

end
