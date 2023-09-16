defmodule PlotquizWeb.TestController do
  use Phoenix.LiveView

  alias Plotquiz.Movie
  alias Plotquiz.Movie.Quiz

  @guesses MapSet.new()
  @time_between_guesses 5

  def render(%{lives: 0} = assigns) do
    :timer.cancel(assigns.t)

    ~H"""
    You are dead
    """
  end

  def render(assigns) do
    ~H"""
    <div phx-window-keyup="update_guess">

    <pre class={"grid h-[40vh] place-items-center text-center tracking-[5px]"}><%= @hint %></pre>

    <div class={"grid w-full place-items-center text-center"}>
        <blockquote><%= @quiz.genres |> Enum.join(", ") %></blockquote>

        Your guess [<%= @guess %>]
        <br/>
        Total lives: <%= @lives %>
        <br/>
        Timer: <%= @timer %> seconds
    </div>

    </div>
    """
  end

  def mount(params, %{}, socket) do
    quiz = Movie.get_quiz!(params["id"])

    answer = quiz.name |> String.downcase()

    {:ok,
     assign(
       socket,
       hint: answer |> update_hint(@guesses),
       answer: answer,
       quiz: quiz,
       guess: "",
       guesses: @guesses,
       timer: @time_between_guesses,
       t: timer_start(),
       lives: min(15, String.length(answer))
     )}
  end

  def handle_info(:tick, socket) do
    cond do
      socket.assigns.lives == 0 ->
        :timer.cancel(socket.assigns.t)

        {:noreply,
         assign(socket,
           lives: socket.assigns.lives - 1,
           timer: @time_between_guesses,
           t: timer_start()
         )}

      socket.assigns.answer == socket.assigns.hint ->
        :timer.cancel(socket.assigns.t)

        {:noreply,
         assign(socket,
           lives: socket.assigns.lives,
           timer: @time_between_guesses
         )}

      true ->
        {:noreply, assign(socket, timer: socket.assigns.timer - 1)}
    end
  end

  def handle_event("update_guess", %{"key" => value}, socket) do
    if is_legal(value) do
      {:noreply, update_guess(value, socket)}
    else
      {:noreply, socket}
    end
  end

  defp timer_start() do
    :timer.send_interval(1_000, self(), :tick) |> elem(1)
  end

  defp update_guess(value, socket) do
    new_guesses =
      socket.assigns.guesses
      |> MapSet.put(value)

    lives =
      if new_guesses == socket.assigns.guesses do
        socket.assigns.lives - 1
      else
        socket.assigns.lives
      end

    hint =
      socket.assigns.answer
      |> update_hint(new_guesses)

    :timer.cancel(socket.assigns.t)

    assign(socket,
      hint: hint,
      guesses: new_guesses,
      guess: value,
      timer: @time_between_guesses,
      t: timer_start(),
      lives: lives
    )
  end

  defp update_hint(text, set) do
    for letter <- text |> String.split("", trim: true) do
      cond do
        is_legal(letter) ->
          if MapSet.member?(set, letter) do
            letter
          else
            "_"
          end

        true ->
          letter
      end
    end
    |> Enum.join()
  end

  defp is_legal(char) do
    char in ~w(a b c d e f g h i j k l m n o p q r s t u v w x y z)
  end
end
