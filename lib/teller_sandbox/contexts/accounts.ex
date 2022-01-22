defmodule TellerSandbox.Contexts.Accounts do
  alias TellerSandbox.Randomizer.{Id, Numeric}
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
        [Map.take(generate_account(gen_id(token)), @accounts)]

      String.length(token) == 33 ->
        nr_accounts = 3
        accs = generate_many_accounts(token, nr_accounts)
        Enum.map(accs, fn i -> Map.take(i, @accounts) end)
    end
  end

  defp generate_many_accounts(token, nr_accounts) do
    Enum.map(1..nr_accounts, fn i -> generate_account(gen_id(Numeric.randomize(token, i))) end)
  end

  def show(token, acc_id) do
    accounts = all(token)

    if Enum.any?(accounts, fn acc -> acc.id == acc_id end) do
      [Map.take(generate_account(acc_id), @accounts)]
    end
  end

  def details(token, acc_id) do
    accounts = all(token)

    if Enum.any?(accounts, fn acc -> acc.id == acc_id end) do
      account = Map.take(generate_account(acc_id), @details)
      [Map.put(account, :links, gen_detail_links(acc_id))]
    end
  end

  def balances(token, acc_id) do
    accounts = all(token)

    if Enum.any?(accounts, fn acc -> acc.id == acc_id end) do
      account = Map.take(generate_account(acc_id), @balances)
      [Map.put(account, :links, gen_balances_links(acc_id))]
    end
  end

  defp gen_id(token), do: "acc_" <> Id.generate(token)

  defp generate_account(acc_id) do
    %{
      currency: gen_currency(""),
      enrollment_id: gen_enrollment_id(acc_id),
      id: acc_id,
      account_id: acc_id,
      account_number: gen_account_number(acc_id),
      institution: gen_institution(acc_id),
      last_four: gen_last_four(acc_id),
      links: gen_links(acc_id),
      routing_numbers: gen_routing_numbers(acc_id),
      name: gen_name(acc_id),
      subtype: gen_subtype(acc_id),
      type: gen_type(acc_id),
      available: gen_available(acc_id),
      ledger: gen_available(acc_id)
    }
  end

  defp gen_currency(_), do: "USD"
  defp gen_enrollment_id(acc_id), do: "enr_" <> Id.get_id_two(acc_id)
  defp gen_account_number(acc_id), do: Numeric.get_numeric(acc_id) |> Integer.to_string()
  defp gen_institution(acc_id), do: Institutions.get_inst(acc_id)
  defp gen_last_four(acc_id), do: gen_account_number(acc_id) |> String.slice(-4, 4)

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
      ach: Numeric.get_numeric(gen_institution(token).id) |> Integer.to_string()
    }
  end

  defp gen_name(token), do: Names.gen_acc_name(token)
  defp gen_subtype(_), do: "checking"
  defp gen_type(_), do: "depository"
  defp gen_available(token), do: Numeric.gen_available(token)
end
