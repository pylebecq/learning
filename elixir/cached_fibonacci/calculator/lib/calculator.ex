defmodule Calculator do
  alias Calculator.Fibonacci

  defdelegate fib(n), to: Fibonacci
end
