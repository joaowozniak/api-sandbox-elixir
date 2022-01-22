defmodule TellerSandbox.Randomizer.Id do
  def generate(token) do
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
end
