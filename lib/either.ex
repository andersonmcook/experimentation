defmodule Monad.Either do
  @moduledoc """
  Data structure
  `left` - {:error, reason}
  `right` - {:ok, data}
  """

  defstruct [:left, :right]

  def new({:error, _} = error), do: %__MODULE__{left: error}
  def new({:ok, _} = success), do: %__MODULE__{right: success}
end
