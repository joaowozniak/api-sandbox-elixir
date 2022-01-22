defmodule TellerSandbox.Contexts.Transactions do
  alias TellerSandbox.Data.{Merchants}
  alias TellerSandbox.Randomizer.{Numeric}

  @base_link "http://localhost:4000/accounts/"

  def generate_transactions(account) do
    start_date = Date.utc_today()
    end_date = Date.add(start_date, -10)

    running_balance = get_running_balance(account)

    [transactions, _] =
      Date.range(end_date, start_date)
      |> Enum.reduce([[], Decimal.new(running_balance)], fn date,
                                                            [transactions, running_balance] ->
        transaction = generate_transaction(account, date, running_balance)
        amount = get_amount(get_trans_key(account, date))
        running_balance = Decimal.sub(running_balance, amount)

        [[transaction | transactions], running_balance]
      end)

    transactions
  end

  def show(transactions, transaction_id) do
    Enum.find(transactions, fn trans -> trans.id == transaction_id end)
  end

  defp generate_transaction(account, date, running_balance) do
    trans_key = get_trans_key(account, date)

    %{
      account_id: get_acc_id(account),
      amount: Decimal.negate(get_amount(trans_key)),
      date: date,
      description: get_merchant(trans_key),
      details:
        get_details(
          get_category(trans_key),
          get_counterparty(get_merchant(trans_key))
        ),
      id: get_trans_id(trans_key),
      links: gen_links(get_acc_id(account), get_trans_id(trans_key)),
      running_balance: running_balance,
      status: get_status(""),
      type: get_type("")
    }
  end

  defp get_acc_id(acc), do: acc.account_id
  defp get_trans_key(acc, date), do: Numeric.gen_trans_key(get_acc_id(acc), date)
  defp get_amount(trans_key), do: Numeric.generate_amount(trans_key)
  defp get_merchant(trans_key), do: Merchants.gen_merch(trans_key)
  defp get_category(trans_key), do: Merchants.gen_categ(trans_key)
  defp get_running_balance(acc), do: acc.available
  defp get_trans_id(trans_key), do: "txn_" <> trans_key
  defp get_status(_), do: "posted"
  defp get_type(_), do: "card_payment"

  defp get_counterparty(merchant),
    do: %{
      name: String.upcase(merchant),
      type: "organization"
    }

  defp get_details(category, counterparty),
    do: %{
      category: category,
      counterparty: counterparty,
      processing_status: "complete"
    }

  defp gen_links(acc_id, transaction_id),
    do: %{
      account: @base_link <> "#{acc_id}",
      self: @base_link <> "#{acc_id}" <> "/transactions/" <> "#{transaction_id}"
    }
end
