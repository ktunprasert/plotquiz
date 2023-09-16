defmodule Plotquiz.MovieFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Plotquiz.Movie` context.
  """

  @doc """
  Generate a quiz.
  """
  def quiz_fixture(attrs \\ %{}) do
    {:ok, quiz} =
      attrs
      |> Enum.into(%{
        name: "some name",
        description: "some description",
        genres: ["option1", "option2"],
        imdb_rating: "some imdb_rating",
        rt_rating: "some rt_rating",
        release_year: 42,
        country_of_origin: "some country_of_origin",
        actors: ["option1", "option2"]
      })
      |> Plotquiz.Movie.create_quiz()

    quiz
  end
end
