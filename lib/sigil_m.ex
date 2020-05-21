defmodule SigilM do
  defmacro sigil_m({:<<>>, _meta, [x]}, modifiers) do
    # IO.inspect(meta, label: :meta)
    IO.inspect(x, label: :x)
    IO.inspect(modifiers, label: :modifiers)

    :elixir_interpolation.unescape_chars(x)
  end

  defmacro sigil_p(term, modifiers)

  defmacro sigil_p({:<<>>, _meta, [string]}, modifiers) when is_binary(string) do
    split_words(:elixir_interpolation.unescape_chars(string), modifiers)
  end

  defmacro sigil_p({:<<>>, meta, pieces}, modifiers) do
    # binary = {:<<>>, meta, unescape_tokens(pieces)}
    # split_words(binary, modifiers)
  end

  # defmacro sigil_p(term, modifiers)

  # defmacro sigil_p({:<<>>, _meta, [string]}, modifiers) when is_binary(string) do
  #   split_words(string, modifiers)
  # end

  defp split_words(string, []) do
    split_words(string, [?s])
  end

  defp split_words(string, [mod])
       when mod == ?s or mod == ?a or mod == ?c do
    case is_binary(string) do
      true ->
        parts = String.split(string)

        case mod do
          ?s -> parts
          ?a -> :lists.map(&String.to_atom/1, parts)
          ?c -> :lists.map(&String.to_charlist/1, parts)
        end

      false ->
        parts = quote(do: String.split(unquote(string)))

        case mod do
          ?s -> parts
          ?a -> quote(do: :lists.map(&String.to_atom/1, unquote(parts)))
          ?c -> quote(do: :lists.map(&String.to_charlist/1, unquote(parts)))
        end
    end
  end

  defp split_words(_string, _mods) do
    raise ArgumentError, "modifier must be one of: s, a, c"
  end
end
