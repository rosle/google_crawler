defmodule GoogleCrawlerWeb.Plugs.SkipAfterAuth do
  @moduledoc """
    To skip the route to user index page if the user is already authenticated.
    Useful for the auth pages like login or register.
  """

  import Plug.Conn
  import Phoenix.Controller
  import GoogleCrawlerWeb.Gettext

  alias GoogleCrawlerWeb.Router.Helpers, as: Routes

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns.user_signed_in? do
      conn
      |> put_flash(:info, gettext("You are already signed in."))
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    else
      conn
    end
  end
end
