defmodule TellerSandbox.Models.Account do
  use Ecto.Schema
  @derive Jason.Encoder

  embedded_schema do
    field(:currency, :string)
    field(:enrollment_id, :string)
    field(:account_id, :string)
    #field(:account_number, :string)
    #embeds_one(:institution, Teller.Institution)
    #field(:last_four, :string)
    #embeds_one(:links, Teller.AccountLink)
    #embeds_one(:routing_number, Teller.RoutingNumber)
    #field(:name, :string)
    #field(:subtype, :string)
    #field(:type, :string)
    #field(:available, :float)
    #field(:ledger, :float)
  end
end
