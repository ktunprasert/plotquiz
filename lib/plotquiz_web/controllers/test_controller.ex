defmodule PlotquizWeb.TestController do
  use Phoenix.LiveView

  alias Plotquiz.Movie
  alias Plotquiz.Movie.Quiz

  @guesses MapSet.new()

  def render(assigns) do
    ~H"""
    <div phx-window-keyup="update_guess">

      <pre class={"grid h-[100vh] place-items-center text-center tracking-[5px]"}>
        <%= @hint %>
        <br/>
        Your guess <%= @guess %>
      </pre>

    </div>
    """
  end

  def mount(params, %{}, socket) do
    answer = params["id"] |> Movie.get_quiz!() |> then(& &1.name) |> String.downcase()

    {:ok,
     assign(
       socket,
       hint: answer |> update_hint(@guesses),
       answer: answer,
       guess: "",
       guesses: @guesses
     )}
  end

  def handle_event("update_guess", %{"key" => value}, socket) do
    if value in ~w(a b c d e f g h i j k l m n o p q r s t u v w x y z) do
      {:noreply, update_guess(value, socket)}
    else
      {:noreply, socket}
    end
  end

  defp update_guess(value, socket) do
    guesses =
      socket.assigns.guesses
      |> MapSet.put(value)

    hint =
      socket.assigns.answer
      |> update_hint(guesses)

    assign(socket, hint: hint, guesses: guesses, guess: value)
  end

  defp update_hint(text, set) do
    for letter <- text |> String.split("", trim: true) do
      if MapSet.member?(set, letter) do
        letter
      else
        "_"
      end
    end
    |> Enum.join()
  end
end
