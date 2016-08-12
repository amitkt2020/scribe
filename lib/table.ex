defmodule Scribe.Table do
  def format(data, rows, cols) do
    widths =
      for c <- 0..cols-1 do
        for r <- 0..rows-1 do
          data
          |> Enum.at(r)
          |> Enum.at(c)
        end
        |> Enum.max_by(fn(x) -> get_length(x) end)
        |> get_length()
      end

    IO.puts separator_line(widths)
    for row <- data do
      IO.puts data_line(row, widths)
      IO.puts separator_line(widths)
    end
  end

  defp get_length(value) do
    value
    |> cell_value(0)
    |> String.length()
  end

  def line_length(widths, cols), do: Enum.sum(widths) + cols + 1

  def separator_line(widths) do
    Enum.reduce(widths, "+", fn(width, acc) ->
      acc <> String.duplicate("-", width) <> "+"
    end)
  end

  def data_line(row, widths) do
    row
    |> Enum.zip(widths)
    |> Enum.reduce("|", fn({value, width}, acc) ->
      #IO.puts("#{width} - #{String.length(cell_value(value, 0))}")
      diff = width - String.length(cell_value(value, 0))
      acc <> cell_value(value, diff) <> "|"
    end)
  end

  def cell_value(x, padding) when padding >= 0 do
    " #{inspect(x)}#{String.duplicate(" ", padding)} "
  end
  def cell_value(x, _padding), do: " #{inspect(x)} "
end