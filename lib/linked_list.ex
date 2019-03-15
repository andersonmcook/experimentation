defmodule LinkedList do
  defstruct [
    :next,
    :value
  ]

  def new do
    %__MODULE__{}
  end

  def new(value) do
    %__MODULE__{value: value}
  end
end

defimpl Collectable, for: LinkedList do
  def into(enum) do
    f = fn
      [], {:cont, curr} -> %LinkedList{next: nil, value: curr}
      acc, {:cont, curr} -> %LinkedList{next: acc, value: curr}
      acc, :done -> acc
      _, :halt -> :ok
    end

    {Enum.reverse(enum), f}
  end
end

defimpl Enumerable, for: LinkedList do
  @doc """
  Handles `:halt` for `Enum.reduce_while/3`
  Handles `:suspend` for ...suspending
  Handles stopping at the end of the `LinkedList`
  Handles when there are more elements to process
  """
  def reduce(_enum, {:halt, acc}, _f), do: {:halted, acc}
  def reduce(enum, {:suspend, acc}, f), do: {:suspended, acc, &reduce(enum, &1, f)}

  # Needed for Collectable
  def reduce(%LinkedList{next: nil, value: nil}, {:cont, acc}, _f) do
    {:done, acc}
  end

  def reduce(%LinkedList{next: nil, value: value}, {:cont, acc}, f) do
    {:cont, acc} = f.(value, acc)
    {:done, acc}
  end

  def reduce(%LinkedList{next: next, value: value}, {:cont, acc}, f),
    do: reduce(next, f.(value, acc), f)

  @doc """
  Returning `{:error, __MODULE__}` derives a default implementation based on `reduce/3`
  """
  def count(_enum), do: {:error, __MODULE__}

  @doc """
  Returning `{:error, __MODULE__}` derives a default implementation based on `reduce/3`
  """
  def member?(_enum, _element), do: {:error, __MODULE__}

  @doc """
  Returning `{:error, __MODULE__}` derives a default implementation based on `reduce/3`
  """
  def slice(__enum), do: {:error, __MODULE__}
end
