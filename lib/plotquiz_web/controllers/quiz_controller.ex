defmodule PlotquizWeb.QuizController do
  use PlotquizWeb, :controller

  alias Plotquiz.Movie
  alias Plotquiz.Movie.Quiz

  action_fallback PlotquizWeb.FallbackController

  def index(conn, _params) do
    movie = Movie.list_movie()
    render(conn, :index, movie: movie)
  end

  def create(conn, %{"quiz" => quiz_params}) do
    with {:ok, %Quiz{} = quiz} <- Movie.create_quiz(quiz_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/movie/#{quiz}")
      |> render(:show, quiz: quiz)
    end
  end

  def show(conn, %{"id" => id}) do
    quiz = Movie.get_quiz!(id)
    render(conn, :show, quiz: quiz)
  end

  def update(conn, %{"id" => id, "quiz" => quiz_params}) do
    quiz = Movie.get_quiz!(id)

    with {:ok, %Quiz{} = quiz} <- Movie.update_quiz(quiz, quiz_params) do
      render(conn, :show, quiz: quiz)
    end
  end

  def delete(conn, %{"id" => id}) do
    quiz = Movie.get_quiz!(id)

    with {:ok, %Quiz{}} <- Movie.delete_quiz(quiz) do
      send_resp(conn, :no_content, "")
    end
  end
end
