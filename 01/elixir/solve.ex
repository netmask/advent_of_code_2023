defmodule Advent do
  def parse_string(<<char::binary-size(1)>> <> <<_::binary>>)
      when char in ["1", "2", "3", "4", "5", "6", "7", "8", "9"],
      do: char

  def parse_string("one" <> <<_::binary>>), do: "1"
  def parse_string("two" <> <<_::binary>>), do: "2"
  def parse_string("three" <> <<_::binary>>), do: "3"
  def parse_string("four" <> <<_::binary>>), do: "4"
  def parse_string("five" <> <<_::binary>>), do: "5"
  def parse_string("six" <> <<_::binary>>), do: "6"
  def parse_string("seven" <> <<_::binary>>), do: "7"
  def parse_string("eight" <> <<_::binary>>), do: "8"
  def parse_string("nine" <> <<_::binary>>), do: "9"

  def parse_string(<<_char::binary-size(1), _rest::binary>>), do: :nonumber
  def parse_string("\n"), do: :end
  def parse_string(""), do: :end

  def parse_line(line, acc \\ [], first \\ nil) do
    case parse_string(line) do
      :end ->
        {acc, first}

      :nonumber ->
        String.slice(line, 1..-1)
        |> parse_line(acc, first)

      number ->
        String.slice(line, 1..-1)
        |> parse_line([number | acc], first || line)
    end
  end
end

File.stream!("input.txt")
|> Enum.map(&Advent.parse_line/1)
|> Enum.map(fn {el, _line} ->
  case Integer.parse(Enum.at(el, -1) <> Enum.at(el, 0)) do
    {num, ""} -> num
    _ -> 0
  end
end)
|> Enum.sum()
|> IO.inspect()
