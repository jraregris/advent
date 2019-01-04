defmodule Term do
  def clear() do
    System.cmd("tput", ["init"])

    IO.ANSI.format([:clear, :home])
    |> IO.write()

    hl()

    IO.ANSI.cursor(4, 0) |> IO.write()
  end

  def timestamp do
    t = DateTime.utc_now()

    sc()

    IO.ANSI.cursor(0, 0) |> IO.write()

    IO.ANSI.format([:light_black, t |> to_string])
    |> IO.write()

    rc()
    t
  end

  def sc do
    System.cmd("tput", ["sc"])
  end

  def rc do
    System.cmd("tput", ["rc"])
  end

  def hl() do
    IO.ANSI.cursor(3, 0) |> IO.write()

    {cols, 0} = System.cmd("tput", ["cols"])
    {n, _} = cols |> Integer.parse()
    List.duplicate("═", n) |> Enum.join() |> IO.write()
  end

  def commit_msg(msg) do
    sc()
    IO.ANSI.cursor(2, 0) |> IO.write()
    IO.ANSI.format([:blue, msg]) |> IO.write()
    rc()
  end

  def timestamp_done(start_time) do
    duration =
      DateTime.utc_now()
      |> DateTime.diff(start_time, :milliseconds)

    sc()

    IO.ANSI.cursor(1, 29) |> IO.write()

    IO.ANSI.format([" ", duration |> to_string, "ms"])
    |> IO.write()

    rc()
  end

  def status(status) do
    {bg_color, msg} =
      case status do
        :ok ->
          {:green_background, "  TEST OK  "}

        :fail ->
          {:red_background, " TEST FAIL "}
      end

    sc()
    IO.ANSI.cursor(1, 35) |> IO.write()

    [" ", bg_color, :black, msg]
    |> IO.ANSI.format()
    |> IO.write()

    rc()
  end

  def gets(msg) do
    IO.gets(msg)
    |> String.trim()
  end

  def puts(msg) do
    msg |> IO.puts()
  end

  def puts(msg, color) do
    IO.ANSI.format([color, msg])
    |> IO.write()
  end

  def warn(msg) do
    puts(msg, :yellow)
  end

  def error(msg) do
    puts(msg, :red)
  end

  def ok(msg) do
    puts(msg, :green)
  end

  def commit_status(status, msg) do
    sc()
    IO.ANSI.cursor(0, 48) |> IO.write()

    case status do
      :ok ->
        ok(msg)

      :error ->
        cond do
          Regex.match?(~r/nothing to commit/, msg) ->
            Term.warn("Nothing to commit")

          true ->
            IO.ANSI.cursor(4, 0) |> IO.write()
            error(msg)
        end
    end

    rc()
  end

  def revert(msg) do
    sc()
    IO.ANSI.cursor(0, 48) |> IO.write()
    IO.ANSI.format([:red, msg]) |> IO.write()
    rc()
  end

  defp tcols do
    {cols, 0} = System.cmd("tput", ["cols"])
    cols |> String.trim() |> String.to_integer()
  end

  def choice(msg) do
    IO.ANSI.cursor(0, tcols() - 30) |> IO.write()

    msg
    |> IO.gets()
    |> String.trim()
    |> String.downcase()
    |> case do
      "n" ->
        :no

      "m" ->
        :message

      _ ->
        :yes
    end
  end

  def set_cursor_to_output() do
    IO.ANSI.cursor(4, 0) |> IO.write()
  end
end

defmodule TCR do
  def test(verbose: verbose) do
    Term.set_cursor_to_output()

    {cmd_output, status} =
      System.cmd("mix", ["test", "--exclude", "pending", "--color"])

    if(status == 0) do
      if(verbose > 0) do
        Term.puts(cmd_output)
      end

      :ok
    else
      Term.puts(cmd_output)
      :fail
    end
  end

  def commit(commit_msg) when is_binary(commit_msg) do
    {_, 0} = System.cmd("git", ["add", "."], into: "")

    {output, status} =
      System.cmd(
        "git",
        ["commit", "--message", commit_msg],
        stderr_to_stdout: true
      )

    case {output, status} do
      {_, 0} -> :ok
      {error, 1} -> {:error, error}
    end
  end

  def revert() do
    {_, 0} = System.cmd("git", ["reset", "--hard"])
    Term.revert("Reverting HARD!")
  end

  def pending() do
    {_, status} = System.cmd("grep", ["--recursive", "@tag :pending", "test"])

    if status == 0 do
      {output, status} =
        System.cmd("mix", ["test", "--only", "pending", "--color"])

      if(status == 0) do
        Term.ok("Pending test OK, remove pending tag!")
      else
        Term.warn("\nPending test(s):")
        Term.puts(output)
      end
    end
  end

  defp puts_error(error) do
  end

  def tcr(commit_msg: commit_msg, verbose: verbose) do
    Term.clear()
    Term.commit_msg(commit_msg)
    Term.hl()
    t = Term.timestamp()

    test = TCR.test(verbose: verbose)

    Term.timestamp_done(t)
    Term.status(test)

    if test == :ok do
      commit_status = TCR.commit(commit_msg)

      case commit_status do
        :ok -> Term.commit_status(:ok, "Commited OK")
        {:error, error} -> Term.commit_status(:error, error)
      end
    end

    if test == :fail do
      TCR.revert()
    end

    TCR.pending()

    prompt()
    |> case do
      :yes ->
        TCR.tcr(commit_msg: commit_msg, verbose: verbose)

      :message ->
        TCR.tcr(commit_msg: get_commit_msg(), verbose: verbose)

      _ ->
        nil
    end
  end

  defp prompt() do
    [
      :reset,
      " Again?",
      :light_black,
      " (m for new msg) ",
      :reset,
      "Y/n? "
    ]
    |> IO.ANSI.format()
    |> Term.choice()
  end

  defp get_commit_msg() do
    Term.gets("Next commit message: ")
  end
end

{opts, whatever, _} =
  OptionParser.parse(
    System.argv(),
    aliases: [v: :verbose, m: :message],
    switches: [verbose: :count, message: :string]
  )

commit_msg = opts[:message] || Enum.join(whatever, " ")
verbose = opts[:verbose] || 0

TCR.tcr(commit_msg: commit_msg, verbose: verbose)
