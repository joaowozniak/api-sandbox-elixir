defmodule TellerSandbox.Randomizer.Id do
  def get_id_one(token) do
    :sha256
    |> :crypto.hash(token)
    |> Base.encode16()
    |> String.downcase()
    |> String.slice(0, 20)
  end

  def get_id_two(token) do
    :sha256
    |> :crypto.hash(token)
    |> Base.encode32()
    |> String.downcase()
    |> String.slice(0, 20)
  end

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
end
