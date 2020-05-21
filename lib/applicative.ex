defprotocol Applicative do
  @fallback_to_any true
  def ap(fa, ff)
  def pure(a, f)
end

defimpl Applicative, for: List do
  def ap(as, fs) do
    for f <- fs, a <- as, do: f.(a)
  end

  defdelegate pure(a, f), to: Applicative.Any
end

defimpl Applicative, for: Tuple do
  def ap({:ok, a}, {:ok, f}), do: {:ok, f.(a)}
  def ap(a, _), do: a

  defdelegate pure(a, f), to: Applicative.Any
end

defimpl Applicative, for: Any do
  def ap(_, _), do: :error
  def pure(a, f), do: f.(a)
end
