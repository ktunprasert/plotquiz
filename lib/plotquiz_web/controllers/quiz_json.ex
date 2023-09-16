defmodule PlotquizWeb.QuizJSON do
  alias Plotquiz.Movie.Quiz

  @doc """
  Renders a list of movie.
  """
  def index(%{movie: movie}) do
    %{data: for(quiz <- movie, do: data(quiz))}
  end

  @doc """
  Renders a single quiz.
  """
  def show(%{quiz: quiz}) do
    %{data: data(quiz)}
  end

  defp data(%Quiz{} = quiz) do
    %{
      id: quiz.id,
      name: quiz.name,
      genres: quiz.genres,
      description: quiz.description,
      imdb_rating: quiz.imdb_rating,
      rt_rating: quiz.rt_rating,
      release_year: quiz.release_year,
      country_of_origin: quiz.country_of_origin,
      actors: quiz.actors
    }
  end
end
