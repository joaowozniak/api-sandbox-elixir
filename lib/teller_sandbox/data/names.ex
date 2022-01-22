defmodule TellerSandbox.Data.Names do
  alias TellerSandbox.Randomizer.Numeric

  @names [
    "My Checking",
    "Jimmy Carter",
    "Ronald Reagan",
    "George H. W. Bush",
    "Bill Clinton",
    "George W. Bush",
    "Barack Obama",
    "Donald Trump"
  ]

  def gen_acc_name(token) do
    Enum.at(
      @names,
      Integer.mod(
        Numeric.get_numeric(String.reverse(token)),
        length(@names)
      )
    )
  end
end
