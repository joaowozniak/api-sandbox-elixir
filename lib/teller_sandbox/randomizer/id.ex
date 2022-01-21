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
end
