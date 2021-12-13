defmodule TellerSandbox.Models.TransactionLink do
  use Ecto.Schema
  @derive Jason.Encoder
  @primary_key false

  embedded_schema do
    field(:account, :string)
    field(:self, :string)
  end
end
