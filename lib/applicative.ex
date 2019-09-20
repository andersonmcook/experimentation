defmodule Applicative do
  @moduledoc """
  WIP
  """

  def ap([_ | _] = as, [f | _] = fs) when is_function(f) do
    # Enum.flat_map(as, fn a -> Enum.map(fs, &1.(a)) end)
    for a <- as, f <- fs, do: f.(a)
  end
end
