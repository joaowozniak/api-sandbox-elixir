defmodule TellerSandbox.Data.Merchants do
  alias TellerSandbox.Randomizer.Id

  @merchants [
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

  @categories [
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

  def gen_merch(transaction_key) do
    Enum.at(
      @merchants,
      Integer.mod(
        Id.get_numeric(transaction_key),
        length(@merchants)
      )
    )
  end

  def gen_categ(transaction_key) do
    Enum.at(
      @categories,
      Integer.mod(
        Id.get_numeric(transaction_key),
        length(@categories)
      )
    )
  end
end
