defmodule Curry do
  defp square, do: fn x -> x * x end
  defp increment, do: fn x -> x + 1 end
  defp add, do: fn x -> fn y -> x + y end end
  defp square_normal(x), do: x * x
  defp increment_normal(x), do: x + 1
  defp add_normal(x, y), do: x + y

  def normal(x, y) do
    add_normal(square_normal(x), increment_normal(y))
  end

  def partial_curry(x, y) do
    add().(square().(x)).(increment().(y))
  end

  def full_curry do
    fn x -> fn y -> add().(square().(x)).(increment().(y)) end end
  end
end
