defmodule TCR do
  def clear() do
    IO.ANSI.format([:clear, :home]) |> IO.write()
  end

  def test(opts \\ %{pending: false}) do
    pending = opts[:pending]

    IO.ANSI.format([:inverse, "TEST"]) |> IO.puts()

    {_, status} =
      System.cmd(
        "mix",
        ["test"],
        into: IO.stream(:stdio, 1)
      )

    case status do
      0 ->
        :ok

      _ ->
        :fail
    end
  end

  def commit() do
    IO.ANSI.format([:inverse, "COMMIT - ADD"]) |> IO.puts()

    {_, 0} = System.cmd("git", ["add", "."], into: "")

    IO.ANSI.format([:inverse, "COMMIT - COMMIT"]) |> IO.puts()

    {output, status} = System.cmd("git", ["commit", "--message", "tcr"])

    case {output, status} do
      {_, 0} -> :ok
    end
  end
end

TCR.clear()
test = TCR.test()

if test == :ok do
  commit = TCR.commit()
end
