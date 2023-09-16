defmodule PlotquizWeb.QuizController do
  use PlotquizWeb, :controller

  alias Plotquiz.Movie
  alias Plotquiz.Movie.Quiz

  def index(conn, _params) do
    movie = Movie.list_movie()
    render(conn, :index, movie: movie)
  end

  def new(conn, _params) do
    changeset = Movie.change_quiz(%Quiz{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"quiz" => quiz_params}) do
    case Movie.create_quiz(quiz_params) do
      {:ok, quiz} ->
        conn
        |> put_flash(:info, "Quiz created successfully.")
        |> redirect(to: ~p"/movie/#{quiz}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    quiz = Movie.get_quiz!(id)
    render(conn, :show, quiz: quiz)
  end

  def edit(conn, %{"id" => id}) do
    quiz = Movie.get_quiz!(id)
    changeset = Movie.change_quiz(quiz)
    render(conn, :edit, quiz: quiz, changeset: changeset)
  end

  def update(conn, %{"id" => id, "quiz" => quiz_params}) do
    quiz = Movie.get_quiz!(id)

    case Movie.update_quiz(quiz, quiz_params) do
      {:ok, quiz} ->
        conn
        |> put_flash(:info, "Quiz updated successfully.")
        |> redirect(to: ~p"/movie/#{quiz}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, quiz: quiz, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    quiz = Movie.get_quiz!(id)
    {:ok, _quiz} = Movie.delete_quiz(quiz)

    conn
    |> put_flash(:info, "Quiz deleted successfully.")
    |> redirect(to: ~p"/movie")
  end
end
