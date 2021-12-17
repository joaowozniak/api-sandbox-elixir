defmodule TellerSandbox.Models.Account do
  use Ecto.Schema
  @derive Jason.Encoder
  @primary_key false

  embedded_schema do
    field(:currency, :string)
    field(:enrollment_id, :string)
    field(:id, :string)
    field(:account_id, :string)
    field(:account_number, :string)
    embeds_one(:institution, TellerSandbox.Models.Institution)
    field(:last_four, :string)
    embeds_one(:links, TellerSandbox.Models.AccountLink)
    embeds_one(:routing_numbers, TellerSandbox.Models.RoutingNumber)
    field(:name, :string)
    field(:subtype, :string)
    field(:type, :string)
    field(:available, :string)
    field(:ledger, :string)
  end

end
