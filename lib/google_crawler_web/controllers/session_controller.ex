defmodule GoogleCrawlerWeb.SessionController do
  use GoogleCrawlerWeb, :controller

  alias GoogleCrawler.Accounts
  alias GoogleCrawler.Accounts.User

  plug :check_user_session when action in [:new]

  def new(conn, _params) do
    changeset = User.changeset(%User{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.auth_user(email, password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("Welcome back"))
        |> put_session(:current_user_id, user.id)
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, gettext("The email or password is incorrect, please try again"))
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  defp check_user_session(conn, _params) do
    if conn.assigns.user_signed_in? do
      conn
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    else
      conn
    end
  end
end
