defmodule TellerSandbox.Contexts.RoutingNumbers do
  # alias TellerSandbox.Models.RoutingNumber

  def get_pseudo_random_from_institution(institution) do
    :sha256 |> :crypto.hash(institution) |> :erlang.phash2()
  end

  def from_institution(institution) do
    %{
      ach: Integer.to_string(get_pseudo_random_from_institution(institution))
    }
  end
end
