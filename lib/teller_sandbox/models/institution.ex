defmodule TellerSandbox.Models.Institution do
  use Ecto.Schema
  @derive Jason.Encoder

  embedded_schema do
    field(:name, :string)
  end

end