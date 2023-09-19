defmodule PlotquizWeb.TestControllerTest do
  use PlotquizWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Plotquiz.Movie.Quiz
  alias Plotquiz.Movie

  describe "mount/3" do
    setup do: setup_movie()

    test "shows error when quiz not found", %{conn: conn} do
      {:ok, view, _html} =
        live(
          conn,
          "/test/-1"
        )

      assert render(view) =~ "Quiz not found"
    end

    test "successfully loads when quiz found", %{conn: conn, movie_id: movie_id} do
      {:ok, view, _html} =
        live(
          conn,
          "/test/#{movie_id}"
        )

      assert render(view) =~ "Your guess"
      assert render(view) =~ "Total lives:"
    end
  end

  describe "handle_info/2" do
    setup do: setup_movie()

    test "handles tick event", %{conn: conn, movie_id: movie_id} do
      {:ok, view, _html} =
        live(
          conn,
          "/test/#{movie_id}"
        )

      # Simulating tick message
      send(view.pid, :tick)

      # This depends on the initial game state and the timer_tick/1 function logic.
      # Assuming 5 seconds between ticks and initial seconds set to 5.
      assert render(view) =~ "Timer: 4 seconds"
    end
  end

  describe "handle_event/3" do
    setup do: setup_movie()

    test "handles update_guess event", %{conn: conn, movie_id: movie_id} do
      {:ok, view, _html} =
        live(conn, "/test/#{movie_id}")

      # Simulating an "update_guess" event for the character "a"
      # Assert based on your game's logic. 
      # Here, I'm just checking if the guess is being shown on the page.
      assert render_keyup(view, "update_guess", %{"key" => "a"}) =~ "Your guess [a]"
    end
  end

  defp setup_movie do
    # Assuming you have a way to create movies, you can use this.
    # If not, replace with your own method to insert or mock data.
    movie = %{name: "Test Movie", genres: ["Action"]} |> Movie.create_quiz() |> elem(1)
    {:ok, movie_id: movie.id}
  end
end
