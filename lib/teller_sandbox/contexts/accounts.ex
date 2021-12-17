defmodule TellerSandbox.Contexts.Accounts do
  alias TellerSandbox.Models.{Account, AccountLink, AccountLinkShort}
  alias TellerSandbox.Contexts.{Institutions, RoutingNumbers}

  @base_link "http://localhost:4000/accounts/"

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
    links = []
    routing_numbers = RoutingNumbers.from_institution(institution.id)
    name = Enum.at(get_all_account_names(), Integer.mod(get_pseudo_random_from_token(String.reverse(token)), length(get_all_account_names())))
    subtype = "checking"
    type = "depository"
    available = get_pseudo_random_from_token(token) |> Integer.to_string() |> String.slice(0,5)

    acc = %Account{
      currency: currency,
      enrollment_id: enrollment_id,
      id: id,
      account_id: id,
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
    acc
  end

  def show_account_attributes(account, view) do
    cond do

      view == "accounts" ->

        links = %AccountLink{
          balances: @base_link <> "#{account.id}/balances",
          details: @base_link <> "#{account.id}/details",
          self: @base_link <> "#{account.id}",
          transactions: @base_link <> "#{account.id}/transactions"
        }
        account = Map.put(account, :links, links)
        keys = [:currency, :enrollment_id, :id, :institution, :last_four, :links, :name, :subtype, :type]
        account = Map.take(account, keys)
        account


      view == "details" ->

        links = %AccountLinkShort{
          account: @base_link <> "#{account.account_id}",
          self: @base_link <> "#{account.account_id}/details"
        }
        account = Map.put(account, :links, links)
        keys = [:account_id, :account_number, :links, :routing_numbers]
        account = Map.take(account,keys)
        account

      view == "balances" ->

        links = %AccountLinkShort{
          account: @base_link <> "#{account.account_id}",
          self: @base_link <> "#{account.account_id}/balances"
        }
        account = Map.put(account, :links, links)
        keys = [:account_id, :available, :ledger, :links]
        account = Map.take(account, keys)
        account

      true -> account
    end
  end


  def from_token(token, view) do

    cond do
      (String.length(token) == 33) ->

        max_nr_of_accounts = 2
        range = Enum.at(Enum.to_list(1..max_nr_of_accounts), Integer.mod(get_pseudo_random_from_token(token), max_nr_of_accounts))
        iterator = Enum.to_list(0..range)

        [accounts, _] =
          iterator
          |> Enum.reduce([[], token], fn i, [accounts, token] ->
            account = generate_account(token)
            token = randomize(token, i)
            [[show_account_attributes(account, view) | accounts], token]

          end)
          accounts

      (String.length(token) == 21) ->
        acc_one = generate_account(token)
        [show_account_attributes(acc_one, view)]
    end
  end


  def get_by_id(accounts, account_id) do
    Enum.find(accounts, fn acc -> acc.id == account_id end)
  end

  defp randomize(token, iterator) do
    :sha256 |> :crypto.hash(token |> String.slice(iterator*11, String.length(token))) |> Base.encode64
  end


  defp get_all_account_names do
    [
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
end
