defmodule TellerSandbox.Models.Account do
  use Ecto.Schema
  @derive Jason.Encoder

  embedded_schema do
    field(:currency, :string)
    field(:enrollment_id, :string)
    embeds_one(:institution, TellerSandbox.Models.Institution)
    field(:last_four, :string)
    embeds_one(:links, TellerSandbox.Models.AccountLink)
    field(:name, :string)
    field(:subtype, :string)
    field(:type, :string)
  end
end
