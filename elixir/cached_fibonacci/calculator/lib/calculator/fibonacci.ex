defmodule Calculator.Fibonacci do
  def fib(0), do: 0
  def fib(1), do: 1
  def fib(n) do
    compute_fib(n, Cache.get(n))
  end

  defp compute_fib(n, nil) do
    v = fib(n - 2) + fib(n - 1)
    Cache.store(n, v)
    v
  end

  defp compute_fib(_n, v) do
    v
  end
end
