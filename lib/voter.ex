defmodule Voter do
  def start(votes) do
    votes
    |> Enum.reduce([0], &accumulate/2)
    |> tl
  end

  defp accumulate(x = 1, acc) do
    acc ++ [List.last(acc) + 1]
  end

  defp accumulate(x = 2, acc) do
    acc ++ [List.last(acc) - 1]
  end

  defp accumulate(_, acc) do
    acc ++ [List.last(acc)]
  end
end
