defmodule TellerSandbox.Contexts.Transactions do
    alias TellerSandbox.Contexts.Accounts
    alias TellerSandbox.Models.{Account,Transaction, Counterparty, TransactionDetail, TransactionLink}

    @base_link "http://localhost:4000/accounts/"

    defp get_pseudo_random_from_string(str) do
        :sha256 |> :crypto.hash(str) |> :erlang.phash2()
    end

    defp get_alfanumeric_from_string(str, date) do
        :sha256 |> :crypto.hash(str <> Calendar.strftime(date, "%y-%m-%d")) |> Base.encode16 |> String.downcase() |> String.slice(0,20)
    end


    def generate_transactions(account) do

        start_date = Date.utc_today()
        end_date = Date.add(start_date, -5)

        running_balance = account.available
        account_id = account.id

        [transactions, _] =
            Date.range(end_date, start_date)
            |> Enum.reduce([[], Decimal.new(running_balance), ], fn date, [transactions, running_balance] ->

                amount = 1
                transaction_key = (:sha256 |> :crypto.hash(get_alfanumeric_from_string(account_id, date)) |> Base.encode16 |> String.downcase() |> String.slice(0,20))
                transaction_id = "txn_" <> transaction_key
                merchant = Enum.at(get_all_merchants(), Integer.mod(get_pseudo_random_from_string(transaction_key), length(get_all_merchants())))
                category = Enum.at(get_all_categories(), Integer.mod(get_pseudo_random_from_string(transaction_key), length(get_all_categories())))
                description = merchant

                counterparty = %Counterparty{
                    name: String.upcase(merchant),
                    type: "organization"
                }

                details = %TransactionDetail{
                    category: category,
                    counterparty: counterparty,
                    processing_status: "complete"
                }

                links = %TransactionLink{
                    account: @base_link <> "#{account_id}",
                    self: @base_link <> "#{account_id}" <> "/transactions/" <> transaction_id
                }

                status = "posted"
                type = "card_payment"

                transaction = %Transaction{
                    account_id: account_id,
                    amount: amount,
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


    defp get_all_merchants() do
        merchants = [
            "Uber",
            "Uber Eats",
            "Lyft",
            "Five Guys",
            "In-N-Out Burger",
            "Chick-Fil-A",
            "AMC",
            "Apple",
            "Amazon",
            "Walmart",
            "Target",
            "Hotel Tonight",
            "Misson Ceviche",
            "The",
            "Caltrain",
            "Wingstop",
            "Slim Chickens",
            "CVS",
            "Duane Reade",
            "Walgreens",
            "Roo",
            "McDonald's",
            "Burger King",
            "KFC",
            "Popeye's",
            "Shake Shack",
            "Lowe's",
            "The Ho",
            "Costco",
            "Kroger",
            "iTunes",
            "Spotify",
            "Best Buy",
            "TJ Maxx",
            "Aldi",
            "Dollar",
            "Macy's",
            "H.E. Butt",
            "Dollar Tree",
            "Verizon Wireless",
            "Sprint PCS",
            "T-Mobil",
            "Starbucks",
            "7-Eleven",
            "AT&T Wireless",
            "Rite Aid",
            "Nordstrom",
            "Ross",
            "Gap",
            "Bed, Bath & Beyond",
            "J.C. Penney",
            "Subway",
            "O'Reilly",
            "Wendy's",
            "Dunkin' D",
            "Petsmart",
            "Dick's Sporting Goods",
            "Sears",
            "Staples",
            "Domino's Pizza",
            "Pizz",
            "Papa John's",
            "IKEA",
            "Office Depot",
            "Foot Locker",
            "Lids",
            "GameStop",
            "Sepho",
            "Panera",
            "Williams-Sonoma",
            "Saks Fifth Avenue",
            "Chipotle Mexican Grill",
            "Exx",
            "Neiman Marcus",
            "Jack In The Box",
            "Sonic",
            "Shell"
        ]
    end

    defp get_all_categories() do
        categories = [
            "accommodation",
            "advertising",
            "bar",
            "charity",
            "clothing",
            "dining",
            "education",
            "entertainment",
            "fuel",
            "groceries",
            "health",
            "home",
            "income",
            "insurance",
            "office",
            "phone",
            "service",
            "shopping",
            "software",
            "sport",
            "tax",
            "transportion",
            "utilities"
        ]
    end

end
