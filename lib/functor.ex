defprotocol Functor do
  def fmap(xs, f)
end

defimpl Functor, for: List do
  defdelegate fmap(xs, f), to: Enum, as: :map
end

# Strings aren't functors
defimpl Functor, for: BitString do
  def fmap(xs, f), do: Regex.replace(~r/./, xs, f)
end

defimpl Functor, for: Tuple do
  def fmap({:ok, x}, f), do: {:ok, f.(x)}
  def fmap({:error, _} = error, _), do: error
end

defmodule FunctorBehaviour do
  # fmap or (<$>) in Haskell
  @callback fmap([term()] | binary(), (term() -> term())) :: [term()] | binary()
end

defmodule ListFunctor do
  @moduledoc """
  Implementation of `FunctorBehaviour` for `List`s.
  """
  @behaviour FunctorBehaviour

  @impl true
  @doc callback: true
  @doc """
  Implements `c:FunctorBehaviour.fmap/2` for `List`s.
  """
  @spec fmap([term()], (term() -> term())) :: [term()]
  def fmap(xs, f) do
    Enum.map(xs, f)
  end
end

defmodule StringFunctor do
  @behaviour FunctorBehaviour

  @impl true
  def fmap(xs, f) do
    Regex.replace(~r/\w/, xs, f)
  end
end

defmodule OKFunctor do
  @behaviour FunctorBehaviour

  @impl true
  def fmap({:ok, x}, f) do
    {:ok, f.(x)}
  end

  @impl true
  def fmap({:error, _} = error, _) do
    error
  end
end
