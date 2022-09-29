defmodule HtmlClientWeb.HangmanView do
  use HtmlClientWeb, :view

  def continue_or_try_again(conn, status) when status in [:won, :lost] do
    button("Try again", to: Routes.hangman_path(conn, :new))
  end

  def continue_or_try_again(conn, _) do
    form_for(conn, Routes.hangman_path(conn, :update), [as: "make_move", method: :put], fn form ->
      [
        """
        <div class="row">
        <div class="column">
        """
        |> raw,
        text_input(form, :guess),
        """
        </div>
        <div class="column">
        """
        |> raw,
        submit("Submit next guess"),
        """
           </div>
         </div>
        """
        |> raw
      ]
    end)
  end

  @status_fields %{
    initializing: {"alert-info", "Guess the word, one letter at a time."},
    good_guess: {"alert-success", "Good guess!"},
    bad_guess: {"alert-warning", "Sorry, that's a bad guess"},
    won: {"alert-success", "You won!"},
    lost: {"alert-danger", "Sorry, you lost."},
    already_used: {"alert-info", "You already used that letter."}
  }

  def move_status(status) do
    {class, message} = @status_fields[status]

    ~s{<div class="alert #{class}">#{message}</div>}
  end

  defdelegate figure_for(turns_left), to: HtmlClientWeb.HangmanView.Helpers.FigureFor
end
