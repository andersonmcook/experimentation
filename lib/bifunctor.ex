defprotocol Bifunctor do
  def bimap(ab, fa, fb)
  # def first(ab, fa)
  # def second(ab, fb)
end

defimpl Bifunctor, for: Tuple do
  # :ok/:error
  @doc """
  ## Examples

    iex> Bifunctor.Tuple.bimap({:ok, 1}, fn _ -> :oops end, fn x -> x + 1 end)
    {:ok, 2}

    iex> Bifunctor.Tuple.bimap({:error, :no}, fn _ -> :oops end, fn x -> x + 1 end)
    {:error, :oops}

    iex> Bifunctor.Tuple.bimap({"yo", %{hey: "hello"}}, &String.upcase/1, &Map.get(&1, :hey))
    {"YO", "hello"}
  """
  def bimap({:error, e}, fa, _), do: {:error, fa.(e)}
  def bimap({:ok, x}, _, fb), do: {:ok, fb.(x)}
  # all other tuples
  def bimap({a, b}, fa, fb), do: {fa.(a), fb.(b)}
end
