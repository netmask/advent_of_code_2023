defmodule Game do

  def fit({game_number, %{"red" => red, "green" => green, "blue" => blue}}) do
    {game_number, !(red > 12 || green > 13 || blue > 14)}
  end

  def parse_game_line(line) do
    [<<"Game ", game_number::binary>>, game_data] = String.split(line, ":")

    {String.to_integer(game_number), parse_plays(game_data) |> IO.inspect()}
  end

  def parse_plays(game_data) do
    String.split(game_data, ";")
    |> Enum.map(fn group ->
      String.split(group, ",")
      |> Enum.map(fn cubes ->
        ["", value, color] = String.split(cubes, " ")

        [String.to_integer(value), String.strip(color)]
      end)
    end)
    |> Enum.reduce(%{}, fn el, acc ->
      Enum.reduce(el, acc, fn [value, color], acc ->
        {_, map} =  Map.get_and_update(acc, color, fn old_value ->
          {old_value, max(old_value || 0, value)}
        end)
        map
      end)

    end)
  end
end

# 12 red cubes, 13 green cubes, and 14 blue

line = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"

File.stream!("input.txt")
|> Stream.map(fn el->
  case Game.parse_game_line(el) |> Game.fit() do
    {game, true} -> game
    _ -> 0
  end
end)
|> Enum.sum()
|> IO.inspect()
