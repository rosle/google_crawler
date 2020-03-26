defmodule GoogleCrawlerWeb.SessionController do
  use GoogleCrawlerWeb, :controller

  alias GoogleCrawler.Accounts
  alias GoogleCrawler.Accounts.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do
    case Accounts.authenticate_user(params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("Welcome back"))
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason} ->
        changeset = User.changeset(%User{}, params)

        conn
        |> put_flash(:error, gettext("The email or password is incorrect, please try again"))
        |> render("new.html", changeset: changeset)
    end
  end
end
