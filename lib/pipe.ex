defmodule Pipe do
  defmacro lhs ~> {call, line, args} do
    value = quote do: value
    args = [value | args || []]

    quote do
      unquote(delegate(lhs)).map(unquote(lhs), fn unquote(value) ->
        unquote({call, line, args})
      end)
    end
  end

  defmacro lhs ~>> {call, line, args} do
    value = quote do: value
    args = [value | args || []]

    quote do
      unquote(delegate(lhs)).flat_map(unquote(lhs), fn unquote(value) ->
        unquote({call, line, args})
      end)
    end
  end

  defp delegate(input) do
    cond do
      is_list(input) -> Enum
      is_tuple(input) -> OK
      true -> Bad
    end
  end
end
