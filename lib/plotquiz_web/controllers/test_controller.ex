defmodule PlotquizWeb.TestController do
  use Phoenix.LiveView

  alias Plotquiz.Movie
  alias Plotquiz.Movie.Quiz

  @guesses MapSet.new()

  def render(assigns) do
    ~H"""
    <div phx-window-keyup="update_guess">

    <pre class={"grid h-[40vh] place-items-center text-center tracking-[5px]"}><%= @hint %></pre>

    <div class={"grid w-full place-items-center text-center"}>
        <blockquote><%= @quiz.genres |> Enum.join(", ") %></blockquote>

        Your guess [<%= @guess %>]
        <br/>
        Total rounds: <%= @rounds %>
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
       rounds: 0
     )}
  end

  def handle_event("update_guess", %{"key" => value}, socket) do
    if is_legal(value) do
      {:noreply, update_guess(value, socket)}
    else
      {:noreply, socket}
    end
  end

  defp update_guess(value, socket) do
    new_guesses =
      socket.assigns.guesses
      |> MapSet.put(value)

    rounds =
      cond do
        new_guesses == socket.assigns.guesses ->
          socket.assigns.rounds

        true ->
          socket.assigns.rounds + 1
      end

    hint =
      socket.assigns.answer
      |> update_hint(new_guesses)

    assign(socket,
      hint: hint,
      guesses: new_guesses,
      guess: value,
      rounds: rounds
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
