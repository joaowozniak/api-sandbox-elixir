defmodule TellerSandbox.Models.RoutingNumber do
  use Ecto.Schema
  @derive Jason.Encoder
  @primary_key false

  embedded_schema do
    field(:ach, :string)
  end

end
