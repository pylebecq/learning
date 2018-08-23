defmodule Cli do
  defdelegate start(), to: Cli.Interact
end
