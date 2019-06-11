defmodule Lens do
  @moduledoc """
  Lens Laws
  1. You get back what you put in: set(lens, value, object) -> object -> get(lens, object) -> value
  2. Putting back what you got doesn't change anything: get(lens, object) -> value -> set(lens, value, object) -> object
  3. Setting twice is the same as setting once
  """
  # TODO: define view, set, over, defining a lens

  defstruct [:get, :set]

  # TODO: have this be a protocol for different types? like you can't always use Map.get
  # TODO: use a protocol so you don't have declare the type? or...do we want to use a protocol? you gotta know something about the structure to even define the lens?

  def new(key, :map) do
    %__MODULE__{
      get: &Map.get(&1, key),
      set: &Map.put(&1, key, &2)
    }
  end

  def new(index, :list) do
    %__MODULE__{
      get: &Enum.at(&1, index),
      set: &List.replace_at(&1, index, &2)
    }
  end

  def new(index, :tuple) do
    %__MODULE__{
      get: &Kernel.elem(&1, index),
      set:
        &(&1
          |> Tuple.delete_at(index)
          |> Tuple.insert_at(index, &2))
    }
  end

  def over(%__MODULE__{get: get, set: set}, coll, f) do
    set.(
      coll,
      coll
      |> get.()
      |> f.()
    )
  end

  def set(%__MODULE__{set: set}, coll, value) do
    set.(coll, value)
  end

  def view(%__MODULE__{get: get}, coll) do
    get.(coll)
  end

  # TODO: think through how to compose/append/etc

  # TODO: make sure `set` works like we want it to

  def compose(%__MODULE__{} = lens_a, %__MODULE__{} = lens_b) do
    %__MODULE__{
      get:
        &(&1
          |> lens_a.get.()
          |> lens_b.get.()),
      set:
        &(&1
          |> lens_a.set.()
          |> lens_b.set.())
    }
  end

  def compose([%__MODULE__{} | _] = lenses) do
    Enum.reduce(lenses, &compose/2)
  end

  def pipe([%__MODULE__{} | _] = lenses) do
    Enum.reduce(lenses, &compose(&2, &1))
  end
end

defmodule Implementation do
  # %{a: [nil, {"hey", "hello"}]}

  def example do
    %{a: [nil, {"hey", "hello"}]}
  end

  def a do
    Lens.new(:a, :map)
  end

  def second_index do
    Lens.new(1, :list)
  end

  def first_elem do
    Lens.new(0, :tuple)
  end
end
