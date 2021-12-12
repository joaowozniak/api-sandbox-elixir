defmodule TellerSandbox.Contexts.Institutions do
  alias TellerSandbox.Models.Institution

  def get_all_institutions() do
    institutions = [
      %{id: "chase", name: "Chase"},
      %{id: "bank_of_america", name: "Bank of America"},
      %{id: "wells_fargo", name: "Wells Fargo"},
      %{id: "citibank", name: "Citibank"},
      %{id: "capital_one", name: "Capital One"}
    ]
  end

  def get_pseudo_random_from_token(token) do
    :sha256 |> :crypto.hash(token) |> :erlang.phash2()
  end

  def from_token(token) do
    institution = Enum.at(get_all_institutions(), Integer.mod(get_pseudo_random_from_token(token), length(get_all_institutions())))
    %Institution{
      id: institution.id,
      name: institution.name
    }
  end

end
