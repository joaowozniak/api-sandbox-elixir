defmodule TellerSandbox.Contexts.Accounts do
  alias TellerSandbox.Randomizer.Id
  alias TellerSandbox.Data.{Institutions, Names}

  @base_link "http://localhost:4000/accounts/"

  def all(token) do
    [generate_account(token)]
  end

  def show(token, acc_id) do
    [Enum.find([generate_account(token)], fn acc -> acc.id == acc_id end)]
  end

  def from_token(token, view) do
    cond do
      String.length(token) == 33 ->
        max_nr_of_accounts = 2

        range =
          Enum.at(
            Enum.to_list(1..max_nr_of_accounts),
            Integer.mod(Id.get_numeric(token), max_nr_of_accounts)
          )

        iterator = Enum.to_list(0..range)

        [accounts, _] =
          iterator
          |> Enum.reduce([[], token], fn i, [accounts, token] ->
            account = generate_account(token)
            token = randomize(token, i)
            [[show_account_attributes(account, view) | accounts], token]
          end)

        accounts

      String.length(token) == 21 ->
        acc_one = generate_account(token)
        [show_account_attributes(acc_one, view)]
    end
  end

  defp generate_account(token) do
    %{
      currency: gen_currency(token),
      enrollment_id: gen_enrollment_id(token),
      id: gen_id(token),
      # account_id: gen_id(token),
      # account_number: gen_account_number(token),
      institution: gen_institution(token),
      last_four: gen_last_four(token),
      links: gen_links(gen_id(token)),
      # routing_numbers: gen_routing_numbers(token),
      name: gen_name(token),
      subtype: gen_subtype(token),
      type: gen_type(token)
      # available: gen_available(token),
      # ledger: gen_available(token)
    }
  end

  defp gen_currency(_token), do: "USD"
  defp gen_enrollment_id(token), do: "enr_" <> Id.get_id_two(token)
  defp gen_id(token), do: "acc_" <> Id.get_id_one(token)
  defp gen_account_number(token), do: Id.get_numeric(token) |> Integer.to_string()
  defp gen_institution(token), do: Institutions.get_inst(token)
  defp gen_last_four(token), do: gen_account_number(token) |> String.slice(-4, 4)

  defp gen_links(acc_id) do
    %{
      balances: @base_link <> "#{acc_id}/balances",
      details: @base_link <> "#{acc_id}/details",
      self: @base_link <> "#{acc_id}",
      transactions: @base_link <> "#{acc_id}/transactions"
    }
  end

  defp gen_routing_numbers(token),
    do: Id.get_numeric(gen_institution(token).id) |> Integer.to_string()

  defp gen_name(token), do: Names.gen_acc_name(token)
  defp gen_subtype(_token), do: "checking"
  defp gen_type(_token), do: "depository"

  defp gen_available(token),
    do: Id.get_numeric(token) |> Integer.to_string() |> String.slice(0, 5)

  def show_account_attributes(account, view) do
    cond do
      view == "accounts" ->
        links = %{
          balances: @base_link <> "#{account.id}/balances",
          details: @base_link <> "#{account.id}/details",
          self: @base_link <> "#{account.id}",
          transactions: @base_link <> "#{account.id}/transactions"
        }

        account = Map.put(account, :links, links)

        keys = [
          :currency,
          :enrollment_id,
          :id,
          :institution,
          :last_four,
          :links,
          :name,
          :subtype,
          :type
        ]

        account = Map.take(account, keys)
        account

      view == "details" ->
        links = %{
          account: @base_link <> "#{account.account_id}",
          self: @base_link <> "#{account.account_id}/details"
        }

        account = Map.put(account, :links, links)
        keys = [:account_id, :account_number, :links, :routing_numbers]
        account = Map.take(account, keys)
        account

      view == "balances" ->
        links = %{
          account: @base_link <> "#{account.account_id}",
          self: @base_link <> "#{account.account_id}/balances"
        }

        account = Map.put(account, :links, links)
        keys = [:account_id, :available, :ledger, :links]
        account = Map.take(account, keys)
        account

      true ->
        account
    end
  end

  defp randomize(token, iterator) do
    :sha256
    |> :crypto.hash(token |> String.slice(iterator * 11, String.length(token)))
    |> Base.encode64()
  end
end
