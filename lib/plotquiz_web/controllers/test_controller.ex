defmodule PlotquizWeb.TestController do
  use Phoenix.LiveView

  alias Plotquiz.Movie
  alias PlotQuiz.HangmanGame

  def render(%{error: _error} = assigns) do
    ~H"<%= @error %>"
  end

  def render(assigns) do
    if assigns.game.lives == 0 do
      :timer.cancel(assigns.game.t)

      ~H"""
      You are dead
      """
    else
      ~H"""
      <div phx-window-keyup="update_guess">

      <pre class={"grid h-[40vh] place-items-center text-center tracking-[5px]"}><%= @game.hint %>
      <code><%= @game.guesses |> MapSet.to_list() |> Enum.join(", ")  %></code>
      </pre>

      <div class={"grid w-full place-items-center text-center"}>
          <blockquote><%= @game.quiz.genres |> Enum.join(", ") %></blockquote>

          Your guess [<%= @game.guess %>]
          <br/>
          Total lives: <%= @game.lives %>
          <br/>
          Timer: <%= @game.seconds %> seconds
      </div>

      </div>
      """
    end
  end

  def mount(params, %{}, socket) do
    try do
      game = HangmanGame.new_game(Movie.get_quiz!(params["id"]))
      {:ok, assign(socket, game: game)}
    rescue
      _e in Ecto.NoResultsError ->
        {:ok, assign(socket, error: "Quiz not found")}
    end
  end

  def handle_info(:tick, socket) do
    game = HangmanGame.timer_tick(socket.assigns.game) |> dbg
    {:noreply, assign(socket, game: game)}
  end

  def handle_event("update_guess", %{"key" => value}, socket) do
    game = HangmanGame.add_guess(socket.assigns.game, value)
    {:noreply, assign(socket, game: game)}
  end
end
