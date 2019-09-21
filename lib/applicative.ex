defprotocol Applicative do
  # def pure(a)
  def ap(fa, ff)
end

defimpl Applicative, for: List do
  # def pure(a), do: [a]

  def ap(as, fs) do
    for f <- fs, a <- as, do: f.(a)
  end
end

defimpl Applicative, for: Tuple do
  # def pure(a), do: {:ok, a}
  def ap({:ok, a}, {:ok, f}), do: {:ok, f.(a)}
  def ap(a, _), do: a
end
