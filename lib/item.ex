defmodule Item do
  defstruct next: nil,
            value: :__none__

  def new do
    %__MODULE__{}
  end

  def new(value) do
    %__MODULE__{value: value}
  end

  def prepend(%__MODULE__{} = item, value) do
    %__MODULE__{next: item, value: value}
  end
end

defimpl Collectable, for: Item do
  @doc """
  Currently does not preserve order
  """
  def into(enum) do
    f = fn
      %Item{value: :__none__}, {:cont, curr} ->
        Item.new(curr)

      acc, {:cont, curr} ->
        Item.prepend(acc, curr)

      acc, :done ->
        acc

      _, :halt ->
        :ok
    end

    {enum, f}
  end
end

defimpl Enumerable, for: Item do
  @doc """
  Handles `:halt` for `Enum.reduce_while/3`
  Handles `:suspend` for ...suspending
  Handles stopping at the end of the `Item`
  Handles when there are more elements to process
  """
  def reduce(_enum, {:halt, acc}, _f), do: {:halted, acc}
  def reduce(enum, {:suspend, acc}, f), do: {:suspended, acc, &reduce(enum, &1, f)}

  def reduce(%Item{next: nil, value: value}, {:cont, acc}, f) do
    {:cont, acc} = f.(value, acc)
    {:done, acc}
  end

  def reduce(%Item{next: next, value: value}, {:cont, acc}, f),
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
  def slice(_enum), do: {:error, __MODULE__}
end
