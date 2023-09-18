defmodule PlotQuiz.HangmanGame do
  defstruct [
    :quiz,
    :answer,
    :hint,
    :guesses,
    :guess,
    :seconds,
    :t,
    :timer,
    :lives
  ]

  @seconds 5

  # Starting a new game
  def new_game(quiz) do
    answer = quiz.name |> String.downcase()

    %__MODULE__{
      quiz: quiz,
      answer: answer,
      hint: update_hint(answer, MapSet.new()),
      guesses: MapSet.new(),
      seconds: @seconds,
      t: timer_start(),
      lives: min(15, String.length(answer))
    }
  end

  def timer_tick(game) do
    cond do
      game.lives == 0 ->
        :timer.cancel(game.t)
        game

      game.seconds == 0 ->
        :timer.cancel(game.t)
        %__MODULE__{game | seconds: @seconds, t: timer_start(), lives: game.lives - 1}

      game.answer == game.hint ->
        :timer.cancel(game.t)
        %__MODULE__{game | seconds: @seconds}

      true ->
        %__MODULE__{game | seconds: game.seconds - 1}
    end
  end

  def add_guess(game, guess) do
    if is_legal(guess), do: update_guess(game, guess), else: game
  end

  def update_guess(game, guess) do
    guesses = MapSet.put(game.guesses, guess)

    {lives, seconds} =
      cond do
        guesses == game.guesses ->
          {game.lives, game.seconds}

        String.contains?(game.answer, guess) ->
          {game.lives, @seconds}

        true ->
          {game.lives - 1, @seconds}
      end

    %__MODULE__{
      game
      | guesses: guesses,
        lives: lives,
        guess: guess,
        hint: update_hint(game.answer, guesses),
        seconds: seconds
    }
  end

  defp update_hint(text, set) do
    for letter <- text |> String.split("", trim: true) do
      cond do
        is_legal(letter) ->
          if MapSet.member?(set, letter) do
            letter
          else
            "_"
          end

        true ->
          letter
      end
    end
    |> Enum.join()
  end

  defp timer_start() do
    :timer.send_interval(1_000, self(), :tick) |> elem(1)
  end

  def is_legal(char) do
    char in ~w(a b c d e f g h i j k l m n o p q r s t u v w x y z)
  end
end
