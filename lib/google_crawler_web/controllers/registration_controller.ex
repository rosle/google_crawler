defmodule GoogleCrawlerWeb.RegistrationController do
  use GoogleCrawlerWeb, :controller

  alias GoogleCrawler.Accounts
  alias GoogleCrawler.Accounts.User

  def new(conn, _params) do
    changeset = User.registration_changeset(%User{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, gettext("You have signed up successfully!"))
        # TODO: Change to login path
        |> redirect(to: Routes.dashboard_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
