defmodule Csvtojson do
  def main(args) do
    args = parse_args(args)
    unless args[:filename], do: System.halt("Usage: ./csvtojson --filename file.csv --output output.json")

    get_content(args[:filename])
      |> csv_to_map_list
      |> map_list_to_json
      |> save_to_file(args[:output])
  end

  defp parse_args(args) do
    OptionParser.parse(args, strict: [filename: :string, output: :string])
    |> extract_valid_args
  end

  defp extract_valid_args({args, _, _}), do: args

  defp get_content(filename) do
    {:ok, content} = File.read(filename)

    content
  end

  defp csv_to_map_list(content) do
    body = String.split(content, "\n")
    [header | lines] = body
    header = String.split(header, ",")
    mount_body(header, lines, [])
  end

  defp mount_body(header, [current | tail], content) do
    current = String.split(current, ",")
    line = mount_line(header, current, %{})
    content = [line | content]
    mount_body(header, tail, content)
  end

  defp mount_body(_, [], body), do: body

  defp mount_line([header_current | header_tail], [cell_current | tail], line) do
    line = Map.put(line, header_current, cell_current)
    mount_line(header_tail, tail, line)
  end

  defp mount_line(_, [], line), do: line

  defp map_list_to_json(map_list) do
    Poison.encode!(map_list, pretty: true)
  end

  defp save_to_file(content, output_file) do
    with :ok <- File.mkdir_p(Path.dirname(output_file)) do
      File.write(output_file, content)
    end

    IO.puts "Saved json content to #{output_file}.json"
  end
end
