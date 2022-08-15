defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  @max 10

  def mount(_params, _session, socket) do
    {:ok, assign(socket, score: 0, message: "Make a guess:", answer: get_answer())}
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
    <%= @message %>
    </h2>
    <h2>
    <%= for n <- 1..10 do %>
    <a href="#" phx-click="guess" phx-value-number= {n} ><%= n %></a>
    <% end %>
    </h2>
    """
  end

  def time() do
    DateTime.utc_now() |> to_string
  end

  def handle_event("guess", %{"number" => guess} = _data, socket) do
    IO.inspect(socket.assigns)
    IO.inspect(guess)
    if guess == socket.assigns.answer do
      {
        :noreply,
        assign(
          socket,
          message: "Your guess: #{guess}. Correct. Play again. ",
          score: socket.assigns.score + 1,
          answer: get_answer()
        )
      }
    else
      {
        :noreply,
        assign(
          socket,
          message: "Your guess: #{guess}. Wrong. Guess again. ",
          score: socket.assigns.score - 1
        )
      }
    end
  end

  defp get_answer(), do: Enum.random(1..@max) |> Integer.to_string()
end
