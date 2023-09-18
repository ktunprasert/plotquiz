defmodule PlotQuiz.HangmanGameTest do
  use ExUnit.Case
  alias PlotQuiz.HangmanGame

  setup do
    # You might want to define a simple quiz struct here.
    # This is just a mock to fit the expected structure of your game initialization.
    quiz = %{
      name: "dog"
    }

    {:ok, quiz: quiz}
  end

  describe "new_game/1" do
    test "starts a new game with the given quiz", %{quiz: quiz} do
      game = HangmanGame.new_game(quiz)
      assert game.quiz == quiz
      assert game.answer == "dog"
      assert game.hint == "___"
      # 15 is the maximum, but the word 'dog' has length 3
      assert game.lives == 3
    end
  end

  describe "timer_tick/1" do
    test "decreases the timer if there are still seconds left", %{quiz: quiz} do
      game = HangmanGame.new_game(quiz)
      new_game = HangmanGame.timer_tick(game)

      assert new_game.seconds == game.seconds - 1
    end

    test "stops timer and returns unchanged game when lives reach 0", %{quiz: quiz} do
      game = HangmanGame.new_game(quiz) |> Map.put(:lives, 0)
      new_game = HangmanGame.timer_tick(game)

      assert new_game.lives == 0
      # Other unchanged attributes
      assert new_game == game
    end

    test "resets the timer and decreases lives when seconds reach 0", %{quiz: quiz} do
      game = HangmanGame.new_game(quiz) |> Map.put(:seconds, 0)
      new_game = HangmanGame.timer_tick(game)

      assert new_game.seconds == 5
      assert new_game.lives == game.lives - 1
    end

    test "returns unchanged game when hint matches answer", %{quiz: quiz} do
      game = HangmanGame.new_game(quiz) |> Map.put(:hint, "dog")
      new_game = HangmanGame.timer_tick(game)

      assert new_game == game
    end
  end

  describe "add_guess/2" do
    test "updates game state when a legal guess is added", %{quiz: quiz} do
      game = HangmanGame.new_game(quiz)
      new_game = HangmanGame.add_guess(game, "d")

      assert new_game.hint == "d__"
      assert MapSet.member?(new_game.guesses, "d")
    end

    test "does not update game state for illegal guesses", %{quiz: quiz} do
      game = HangmanGame.new_game(quiz)
      new_game = HangmanGame.add_guess(game, "1")

      assert new_game == game
    end

    test "doesn't change lives for duplicate guesses", %{quiz: quiz} do
      game = HangmanGame.new_game(quiz) |> Map.put(:guesses, MapSet.new(["d"]))
      new_game = HangmanGame.update_guess(game, "d")

      assert new_game.lives == game.lives
    end

    test "decreases lives for incorrect new guesses", %{quiz: quiz} do
      game = HangmanGame.new_game(quiz)
      new_game = HangmanGame.update_guess(game, "x")

      assert new_game.lives == game.lives - 1
    end

    test "keeps the same number of lives for correct new guesses", %{quiz: quiz} do
      game = HangmanGame.new_game(quiz)
      new_game = HangmanGame.update_guess(game, "d")

      assert new_game.lives == game.lives
    end
  end

  describe "is_legal/1" do
    test "returns true for legal characters" do
      assert HangmanGame.is_legal("a") == true
      assert HangmanGame.is_legal("z") == true
    end

    test "returns false for illegal characters" do
      assert HangmanGame.is_legal("1") == false
      assert HangmanGame.is_legal("!") == false
      assert HangmanGame.is_legal(" ") == false
    end
  end
end
