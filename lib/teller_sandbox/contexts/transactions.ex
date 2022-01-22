defmodule TellerSandbox.Contexts.Transactions do
  alias TellerSandbox.Data.{Merchants}

  @base_link "http://localhost:4000/accounts/"

  defp get_pseudo_random_from_string(str) do
    :sha256 |> :crypto.hash(str) |> :erlang.phash2()
  end

  defp generate_amount(str) do
    max_val = 100
    Enum.at(Enum.to_list(1..max_val), Integer.mod(get_pseudo_random_from_string(str), max_val))
  end

  defp get_alfanumeric_from_string(str, date) do
    :sha256
    |> :crypto.hash(str <> Calendar.strftime(date, "%y-%m-%d"))
    |> Base.encode16()
    |> String.downcase()
    |> String.slice(0, 20)
  end

  def generate_transactions(account) do
    start_date = Date.utc_today()
    end_date = Date.add(start_date, -10)

    running_balance = account.available
    account_id = account.account_id

    [transactions, _] =
      Date.range(end_date, start_date)
      |> Enum.reduce([[], Decimal.new(running_balance)], fn date,
                                                            [transactions, running_balance] ->
        transaction_key =
          :sha256
          |> :crypto.hash(get_alfanumeric_from_string(account_id, date))
          |> Base.encode16()
          |> String.downcase()
          |> String.slice(0, 20)

        transaction_id = "txn_" <> transaction_key
        amount = generate_amount(transaction_key)

        merchant = Merchants.gen_merch(transaction_key)

        category = Merchants.gen_categ(transaction_key)

        description = merchant

        counterparty = %{
          name: String.upcase(merchant),
          type: "organization"
        }

        details = %{
          category: category,
          counterparty: counterparty,
          processing_status: "complete"
        }

        links = %{
          account: @base_link <> "#{account_id}",
          self: @base_link <> "#{account_id}" <> "/transactions/" <> transaction_id
        }

        status = "posted"
        type = "card_payment"

        transaction = %{
          account_id: account_id,
          amount: Decimal.negate(amount),
          date: date,
          description: description,
          details: details,
          id: transaction_id,
          links: links,
          running_balance: running_balance,
          status: status,
          type: type
        }

        running_balance = Decimal.sub(running_balance, amount)

        [[transaction | transactions], running_balance]
      end)

    transactions
  end

  def get_by_id(transactions, transaction_id) do
    Enum.find(transactions, fn trans -> trans.id == transaction_id end)
  end
end
