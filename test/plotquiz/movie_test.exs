defmodule Plotquiz.MovieTest do
  use Plotquiz.DataCase

  alias Plotquiz.Movie

  describe "movie" do
    alias Plotquiz.Movie.Quiz

    import Plotquiz.MovieFixtures

    @invalid_attrs %{name: nil, description: nil, genres: nil, imdb_rating: nil, rt_rating: nil, release_year: nil, country_of_origin: nil, actors: nil}

    test "list_movie/0 returns all movie" do
      quiz = quiz_fixture()
      assert Movie.list_movie() == [quiz]
    end

    test "get_quiz!/1 returns the quiz with given id" do
      quiz = quiz_fixture()
      assert Movie.get_quiz!(quiz.id) == quiz
    end

    test "create_quiz/1 with valid data creates a quiz" do
      valid_attrs = %{name: "some name", description: "some description", genres: ["option1", "option2"], imdb_rating: "some imdb_rating", rt_rating: "some rt_rating", release_year: 42, country_of_origin: "some country_of_origin", actors: ["option1", "option2"]}

      assert {:ok, %Quiz{} = quiz} = Movie.create_quiz(valid_attrs)
      assert quiz.name == "some name"
      assert quiz.description == "some description"
      assert quiz.genres == ["option1", "option2"]
      assert quiz.imdb_rating == "some imdb_rating"
      assert quiz.rt_rating == "some rt_rating"
      assert quiz.release_year == 42
      assert quiz.country_of_origin == "some country_of_origin"
      assert quiz.actors == ["option1", "option2"]
    end

    test "create_quiz/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Movie.create_quiz(@invalid_attrs)
    end

    test "update_quiz/2 with valid data updates the quiz" do
      quiz = quiz_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", genres: ["option1"], imdb_rating: "some updated imdb_rating", rt_rating: "some updated rt_rating", release_year: 43, country_of_origin: "some updated country_of_origin", actors: ["option1"]}

      assert {:ok, %Quiz{} = quiz} = Movie.update_quiz(quiz, update_attrs)
      assert quiz.name == "some updated name"
      assert quiz.description == "some updated description"
      assert quiz.genres == ["option1"]
      assert quiz.imdb_rating == "some updated imdb_rating"
      assert quiz.rt_rating == "some updated rt_rating"
      assert quiz.release_year == 43
      assert quiz.country_of_origin == "some updated country_of_origin"
      assert quiz.actors == ["option1"]
    end

    test "update_quiz/2 with invalid data returns error changeset" do
      quiz = quiz_fixture()
      assert {:error, %Ecto.Changeset{}} = Movie.update_quiz(quiz, @invalid_attrs)
      assert quiz == Movie.get_quiz!(quiz.id)
    end

    test "delete_quiz/1 deletes the quiz" do
      quiz = quiz_fixture()
      assert {:ok, %Quiz{}} = Movie.delete_quiz(quiz)
      assert_raise Ecto.NoResultsError, fn -> Movie.get_quiz!(quiz.id) end
    end

    test "change_quiz/1 returns a quiz changeset" do
      quiz = quiz_fixture()
      assert %Ecto.Changeset{} = Movie.change_quiz(quiz)
    end
  end
end
