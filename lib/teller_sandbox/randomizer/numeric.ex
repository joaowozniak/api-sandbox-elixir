defmodule TellerSandbox.Randomizer.Numeric do
  def get_numeric(token) do
    :sha256 |> :crypto.hash(token) |> :erlang.phash2()
  end

  def randomize(token, iterator) do
    :sha256
    |> :crypto.hash(token |> String.slice(iterator * 11, String.length(token)))
    |> Base.encode64()
  end

  def gen_available(token) do
    get_numeric(token) |> Integer.to_string() |> String.slice(0, 5)
  end

  def generate_amount(str) do
    max_val = 100
    Enum.at(Enum.to_list(1..max_val), Integer.mod(get_numeric(str), max_val))
  end

  def get_alfanumeric_date(str, date) do
    :sha256
    |> :crypto.hash(str <> Calendar.strftime(date, "%y-%m-%d"))
    |> Base.encode16()
    |> String.downcase()
    |> String.slice(0, 20)
  end

  def gen_trans_key(account_id, date) do
    :sha256
    |> :crypto.hash(get_alfanumeric_date(account_id, date))
    |> Base.encode16()
    |> String.downcase()
    |> String.slice(0, 20)
  end
end
