defmodule TellerSandbox.Models.Transaction do
  use Ecto.Schema
  @derive Jason.Encoder
  @primary_key false

  embedded_schema do
    field(:account_id, :string)
    field(:amount, :string)
    field(:date, :string)
    field(:description, :string)
    embeds_one(:details, TellerSandbox.Models.TransactionDetail)
    field(:id, :string)
    embeds_one(:links, TellerSandbox.Models.TransactionLink)
    field(:running_balance, :string)
    field(:status, :string)
    field(:type, :string)
  end

end
