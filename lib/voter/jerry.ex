defmodule Voter.Jerry do
  def gerrymander(map, {width, height}, num_districts) do
    do_a_jerry([{map, {{0, width}, {0, height}}, 0}], num_districts)
      |> Enum.map(fn({map, _size, num}) ->
        IO.puts :stderr, num
        cond do
          num > 0 ->
            {map, :blue}

          num < 0 ->
            {map, :red}

          true ->
            {map, :draw}
        end
      end)
  end

  defp do_a_jerry(list, 1) do
    list
  end

  defp do_a_jerry(list, depth) do
    [{map, size, _} | untouched_list] = list |> Enum.shuffle

    {a, b} = if :random.uniform > 0.5 do
      {_, {min_y, max_y}} = size
      random = round(0.8 * :random.uniform * (max_y - min_y) + min_y)
      split_y(map, size, random)
    else
      {{min_x, max_x}, _} = size
      random = round(0.8 * :random.uniform * (max_x - min_x) + min_x)
      split_x(map, size, random)
    end

    do_a_jerry([a, b | untouched_list], depth - 1)
  end

  defp split_x(map, {{min_x, max_x}, y_range}, val) do
    district_0 = {%{}, {{min_x, val}, y_range}, 0}
    district_1 = {%{}, {{val + 1, max_x}, y_range}, 0}
    map |> Map.to_list
      |> Enum.reduce({district_0, district_1}, fn({{x, y}, vote}, {district_0, district_1}) ->
        if x < val do
          {map, size, total} = district_0
          {{Map.put(map, {x, y}, vote), size, total + vote}, district_1}
        else
          {map, size, total} = district_1
          {district_0, {Map.put(map, {x, y}, vote), size, total + vote}}
        end
      end)
  end

  defp split_y(map, {x_range, {min_y, max_y}}, val) do
    district_0 = {%{}, {x_range, {min_y, val}}, 0}
    district_1 = {%{}, {x_range, {val + 1, max_y}}, 0}
    map |> Map.to_list
      |> Enum.reduce({district_0, district_1}, fn({{x, y}, vote}, {district_0, district_1}) ->
        if y < val do
          {map, size, total} = district_0
          {{Map.put(map, {x, y}, vote), size, total + vote}, district_1}
        else
          {map, size, total} = district_1
          {district_0, {Map.put(map, {x, y}, vote), size, total + vote}}
        end
      end)
  end
end
