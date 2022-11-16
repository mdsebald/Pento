defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  def mount(_params, session, socket) do
    {:ok,
     assign(socket,
       score: 0,
       message: "Guess a number: ",
       session_id: session["live_socket_id"],
       answer: :rand.uniform(10)
     )}
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    </h2>
    <h2>
      <%= if String.contains?(@message, "Correct") do %>
      <%= live_patch "Reset", to: nil %>
      <% end %>
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
      <a href="#" phx-click="guess" phx-value-number= {n} ><%= n %></a>
      <% end %>
      <pre>
        <%= @current_user.email %>
        <%= @session_id %>
      </pre>
    </h2>
    """
  end

  # def time() do
  #   DateTime.utc_now() |> DateTime.truncate(:second) |> DateTime.to_string()
  # end

  def handle_event("guess", %{"number" => guess} = data, socket) do
    IO.inspect(socket.assigns.answer, label: "Answer")

    {message, score, answer} =
      if String.to_integer(guess) == socket.assigns.answer do
        {"Your guess: #{guess}. Correct.", socket.assigns.score + 1, :rand.uniform(10)}
      else
        {"Your guess: #{guess}. Wrong. Guess again. ", socket.assigns.score - 1,
         socket.assigns.answer}
      end

    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score,
        answer: answer
      )
    }
  end
end
