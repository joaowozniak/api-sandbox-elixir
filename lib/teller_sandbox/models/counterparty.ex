defmodule TellerSandbox.Models.Counterparty do
  use Ecto.Schema
  @derive Jason.Encoder
  @primary_key false

  embedded_schema do
    field(:name, :string)
    field(:type, :string)
  end

end
