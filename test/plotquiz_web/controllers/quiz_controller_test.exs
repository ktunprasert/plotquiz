defmodule PlotquizWeb.QuizControllerTest do
  use PlotquizWeb.ConnCase

  import Plotquiz.MovieFixtures

  alias Plotquiz.Movie.Quiz

  @create_attrs %{
    name: "some name",
    description: "some description",
    genres: ["option1", "option2"],
    imdb_rating: "some imdb_rating",
    rt_rating: "some rt_rating",
    release_year: 42,
    country_of_origin: "some country_of_origin",
    actors: ["option1", "option2"]
  }
  @update_attrs %{
    name: "some updated name",
    description: "some updated description",
    genres: ["option1"],
    imdb_rating: "some updated imdb_rating",
    rt_rating: "some updated rt_rating",
    release_year: 43,
    country_of_origin: "some updated country_of_origin",
    actors: ["option1"]
  }
  @invalid_attrs %{name: nil, description: nil, genres: nil, imdb_rating: nil, rt_rating: nil, release_year: nil, country_of_origin: nil, actors: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all movie", %{conn: conn} do
      conn = get(conn, ~p"/api/movie")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create quiz" do
    test "renders quiz when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/movie", quiz: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/movie/#{id}")

      assert %{
               "id" => ^id,
               "actors" => ["option1", "option2"],
               "country_of_origin" => "some country_of_origin",
               "description" => "some description",
               "genres" => ["option1", "option2"],
               "imdb_rating" => "some imdb_rating",
               "name" => "some name",
               "release_year" => 42,
               "rt_rating" => "some rt_rating"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/movie", quiz: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update quiz" do
    setup [:create_quiz]

    test "renders quiz when data is valid", %{conn: conn, quiz: %Quiz{id: id} = quiz} do
      conn = put(conn, ~p"/api/movie/#{quiz}", quiz: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/movie/#{id}")

      assert %{
               "id" => ^id,
               "actors" => ["option1"],
               "country_of_origin" => "some updated country_of_origin",
               "description" => "some updated description",
               "genres" => ["option1"],
               "imdb_rating" => "some updated imdb_rating",
               "name" => "some updated name",
               "release_year" => 43,
               "rt_rating" => "some updated rt_rating"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, quiz: quiz} do
      conn = put(conn, ~p"/api/movie/#{quiz}", quiz: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete quiz" do
    setup [:create_quiz]

    test "deletes chosen quiz", %{conn: conn, quiz: quiz} do
      conn = delete(conn, ~p"/api/movie/#{quiz}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/movie/#{quiz}")
      end
    end
  end

  defp create_quiz(_) do
    quiz = quiz_fixture()
    %{quiz: quiz}
  end
end
