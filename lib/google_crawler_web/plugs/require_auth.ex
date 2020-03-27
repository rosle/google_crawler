defmodule GoogleCrawlerWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller
  import GoogleCrawlerWeb.Gettext

  alias GoogleCrawlerWeb.Router.Helpers, as: Routes

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns.user_signed_in? do
      conn
    else
      conn
      |> put_flash(:error, gettext("You need to sign in or sign up before continuing."))
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end
end
