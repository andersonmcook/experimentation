defprotocol Monoid do
  def mappend(x, y)
  def mconcat(xs)
  def mempty(x)
  # protocol functions expect at least one argument
end

defimpl Monoid, for: List do
  def mappend(x, y), do: x ++ y

  @doc """
  Calls to `Monoid.mempty/1` and `Monoid.mappend/2` instead of local
  to be able to work with lists of strings
  """
  def mconcat([x | _] = xs), do: List.foldr(xs, Monoid.mempty(x), &Monoid.mappend/2)
  def mempty(_), do: []
end

defimpl Monoid, for: BitString do
  def mappend(x, y), do: x <> y

  @doc """
  Defining an implementation A for data type B will give you a module A.B
  """
  defdelegate mconcat(xs), to: Monoid.List
  def mempty(_), do: ""
end

defmodule SemigroupBehaviour do
  # (<>) in Haskell
  @callback append(term(), term()) :: term()
end

defmodule MonoidBehaviour do
  @callback mappend(term(), term()) :: term()
  @callback mconcat([term()]) :: term()
  @callback mempty() :: term()
end

defmodule ListMonoid do
  @moduledoc """
  `++` is our associative binary operation.
  If we were to declare List as an instance of Semigroup, this is all we would need to define.
  """

  @behaviour MonoidBehaviour

  @doc """
  Identity
  """
  @impl true
  def mempty do
    []
  end

  @doc """
  Associative binary operation
  """
  @impl true
  def mappend(x, y) when is_list(x) and is_list(y) do
    x ++ y
  end

  # list of lists
  @impl true
  def mconcat(xs) when is_list(xs) do
    List.foldr(xs, mempty(), &mappend/2)
  end
end

defmodule StringMonoid do
  @moduledoc """
  `<>` is our associative binary operation.
  If we were to declare String as an instance of Semigroup, this is all we would need to define.
  """

  @behaviour MonoidBehaviour

  @doc """
  Identity
  """
  @impl true
  def mempty do
    ""
  end

  @doc """
  Associative binary operation
  """
  @impl true
  def mappend(x, y) when is_binary(x) and is_binary(y) do
    x <> y
  end

  # list of strings
  @impl true
  def mconcat(xs) when is_list(xs) do
    List.foldr(xs, mempty(), &mappend/2)
  end
end

defmodule AdditionMonoid do
  @moduledoc """
  `+` is our associative binary operation.
  If we were to declare Addition as an instance of Semigroup, this is all we would need to define.
  """

  @behaviour MonoidBehaviour

  @doc """
  Identity
  """
  @impl true
  def mempty do
    0
  end

  @doc """
  Associative binary operation
  """
  @impl true
  def mappend(x, y) when is_number(x) and is_number(y) do
    x + y
  end

  # list of numbers
  @impl true
  def mconcat(xs) when is_list(xs) do
    List.foldr(xs, mempty(), &mappend/2)
  end
end

defmodule StructMonoid do
  @moduledoc """
  Put it all together.
  """

  @behaviour MonoidBehaviour

  defstruct list: ListMonoid.mempty(),
            string: StringMonoid.mempty(),
            addition: AdditionMonoid.mempty()

  @impl true
  def mempty do
    %__MODULE__{}
  end

  @impl true
  def mappend(%__MODULE__{} = x, %__MODULE__{} = y) do
    %__MODULE__{
      list: ListMonoid.mappend(x.list, y.list),
      string: StringMonoid.mappend(x.string, y.string),
      addition: AdditionMonoid.mappend(x.addition, y.addition)
    }
  end

  @impl true
  def mconcat(xs) when is_list(xs) do
    List.foldr(xs, mempty(), &mappend/2)
  end

  def show_mappend do
    mappend(
      %__MODULE__{
        list: [1, 2, 3],
        string: "ABC",
        addition: 10
      },
      %__MODULE__{
        list: [4, 5, 6],
        string: "DEF",
        addition: 10
      }
    )
  end

  def show_mconcat do
    mconcat([
      %__MODULE__{
        list: [1, 2, 3],
        string: "ABC",
        addition: 11
      },
      %__MODULE__{
        list: [4, 5, 6],
        string: "DEF",
        addition: 11
      },
      %__MODULE__{
        list: [7, 8, 9],
        string: "HIJ",
        addition: 11
      }
    ])
  end
end
