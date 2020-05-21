defmodule Arrow do
  def fanout(a, f, g), do: {f.(a), g.(a)}

  def f &&& g do
    &fanout(&1, f, g)
  end

  def first({a, b}, f), do: {f.(a), b}
  def product({a, b}, f, g), do: {f.(a), g.(b)}

  def f ^^^ g do
    &product(&1, f, g)
  end

  def second({a, b}, g), do: {a, g.(b)}
  # fanout with identity
  def split(a), do: {a, a}
  def swap({a, b}), do: {b, a}
  def unsplit({a, b}, f), do: f.(a, b)

  # "6!? 39"
  def demo do
    6
    |> fanout(&square/1, &to_string/1)
    |> first(&inc/1)
    |> second(&bang/1)
    |> product(&inc2/1, &question/1)
    |> swap()
    |> unsplit(&stringify/2)
  end

  defp square(x), do: x * x
  defp inc(x), do: x + 1
  defp bang(x), do: x <> "!"
  defp inc2(x), do: x + 2
  defp question(x), do: x <> "?"
  defp stringify(x, y), do: "#{x} #{y}"
end
