defprotocol Monad do
  def bind(xs, f)
end

defimpl Monad, for: List do
  defdelegate bind(xs, f), to: Enum, as: :flat_map
end

defimpl Monad, for: Tuple do
  def bind({:ok, x}, f), do: f.(x)
  def bind({:error, _} = error), do: error
end

defmodule MonadBehaviour do
  @type result() :: {:ok | :error, term()}
  # (>>=) in Haskell
  @callback bind(result(), (term() -> result())) :: result()
end

defmodule ListMonad do
  @behaviour MonadBehaviour

  @impl true
  def bind([], _), do: []

  @impl true
  def bind(xs, f) do
    Enum.flat_map(xs, f)
  end
end

defmodule OKMonad do
  @behaviour MonadBehaviour

  @impl true
  def bind({:ok, x}, f) do
    f.(x)
  end

  @impl true
  def bind({:error, _} = error, _) do
    error
  end
end
