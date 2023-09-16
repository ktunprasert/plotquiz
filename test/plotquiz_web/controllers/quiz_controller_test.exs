defmodule PlotquizWeb.QuizControllerTest do
  use PlotquizWeb.ConnCase

  import Plotquiz.MovieFixtures

  @create_attrs %{name: "some name", description: "some description", genres: ["option1", "option2"], imdb_rating: "some imdb_rating", rt_rating: "some rt_rating", release_year: 42, country_of_origin: "some country_of_origin", actors: ["option1", "option2"]}
  @update_attrs %{name: "some updated name", description: "some updated description", genres: ["option1"], imdb_rating: "some updated imdb_rating", rt_rating: "some updated rt_rating", release_year: 43, country_of_origin: "some updated country_of_origin", actors: ["option1"]}
  @invalid_attrs %{name: nil, description: nil, genres: nil, imdb_rating: nil, rt_rating: nil, release_year: nil, country_of_origin: nil, actors: nil}

  describe "index" do
    test "lists all movie", %{conn: conn} do
      conn = get(conn, ~p"/movie")
      assert html_response(conn, 200) =~ "Listing Movie"
    end
  end

  describe "new quiz" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/movie/new")
      assert html_response(conn, 200) =~ "New Quiz"
    end
  end

  describe "create quiz" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/movie", quiz: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/movie/#{id}"

      conn = get(conn, ~p"/movie/#{id}")
      assert html_response(conn, 200) =~ "Quiz #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/movie", quiz: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Quiz"
    end
  end

  describe "edit quiz" do
    setup [:create_quiz]

    test "renders form for editing chosen quiz", %{conn: conn, quiz: quiz} do
      conn = get(conn, ~p"/movie/#{quiz}/edit")
      assert html_response(conn, 200) =~ "Edit Quiz"
    end
  end

  describe "update quiz" do
    setup [:create_quiz]

    test "redirects when data is valid", %{conn: conn, quiz: quiz} do
      conn = put(conn, ~p"/movie/#{quiz}", quiz: @update_attrs)
      assert redirected_to(conn) == ~p"/movie/#{quiz}"

      conn = get(conn, ~p"/movie/#{quiz}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, quiz: quiz} do
      conn = put(conn, ~p"/movie/#{quiz}", quiz: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Quiz"
    end
  end

  describe "delete quiz" do
    setup [:create_quiz]

    test "deletes chosen quiz", %{conn: conn, quiz: quiz} do
      conn = delete(conn, ~p"/movie/#{quiz}")
      assert redirected_to(conn) == ~p"/movie"

      assert_error_sent 404, fn ->
        get(conn, ~p"/movie/#{quiz}")
      end
    end
  end

  defp create_quiz(_) do
    quiz = quiz_fixture()
    %{quiz: quiz}
  end
end
