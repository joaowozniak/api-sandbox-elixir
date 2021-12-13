defmodule TellerSandbox.Models.TransactionDetail do
  use Ecto.Schema
  @derive Jason.Encoder
  @primary_key false

  embedded_schema do
    field(:category, :string)
    embeds_one(:counterparty, TellerSandbox.Models.Counterparty)
    field(:processing_status, :string)
  end

end
