defmodule TellerSandbox.Contexts.Accounts do
  alias TellerSandbox.Randomizer.Id
  alias TellerSandbox.Data.{Institutions, Names}

  @base_link "http://localhost:4000/accounts/"
  @accounts [
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

  @details [:account_id, :account_number, :links, :routing_numbers]
  @balances [:account_id, :available, :ledger, :links]

  def all(token) do
    cond do
      String.length(token) == 21 ->
        [Map.take(generate_account(token), @accounts)]

      true ->
        :ok
    end
  end

  def show(token, acc_id) do
    [Enum.find([Map.take(generate_account(token), @accounts)], fn acc -> acc.id == acc_id end)]
  end

  def details(token, acc_id) do
    account =
      Enum.find([Map.take(generate_account(token), @details)], fn acc ->
        acc.account_id == acc_id
      end)

    if account do
      [Map.put(account, :links, gen_detail_links(acc_id))]
    end
  end

  def balances(token, acc_id) do
    account =
      Enum.find([Map.take(generate_account(token), @balances)], fn acc ->
        acc.account_id == acc_id
      end)

    if account do
      [Map.put(account, :links, gen_balances_links(acc_id))]
    end
  end

  defp generate_accounts(token, iterator) do
    [accounts, _] =
      iterator
      |> Enum.reduce([[], token], fn i, [accounts, token] ->
        account = generate_account(token)
        token = randomize(token, i)
        [[[Map.take(account, @account_keys)] | accounts], token]
      end)

    accounts
  end

  defp generate_account(token) do
    %{
      currency: gen_currency(token),
      enrollment_id: gen_enrollment_id(token),
      id: gen_id(token),
      account_id: gen_id(token),
      account_number: gen_account_number(token),
      institution: gen_institution(token),
      last_four: gen_last_four(token),
      links: gen_links(gen_id(token)),
      routing_numbers: gen_routing_numbers(token),
      name: gen_name(token),
      subtype: gen_subtype(token),
      type: gen_type(token),
      available: gen_available(token),
      ledger: gen_available(token)
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

  defp gen_detail_links(acc_id) do
    %{
      account: @base_link <> "#{acc_id}",
      self: @base_link <> "#{acc_id}/details"
    }
  end

  defp gen_balances_links(acc_id) do
    %{
      account: @base_link <> "#{acc_id}",
      self: @base_link <> "#{acc_id}/balances"
    }
  end

  defp gen_routing_numbers(token) do
    %{
      ach: Id.get_numeric(gen_institution(token).id) |> Integer.to_string()
    }
  end

  defp gen_name(token), do: Names.gen_acc_name(token)
  defp gen_subtype(_token), do: "checking"
  defp gen_type(_token), do: "depository"

  defp gen_available(token),
    do: Id.get_numeric(token) |> Integer.to_string() |> String.slice(0, 5)

  defp randomize(token, iterator) do
    :sha256
    |> :crypto.hash(token |> String.slice(iterator * 11, String.length(token)))
    |> Base.encode64()
  end
end
