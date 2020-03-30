defmodule GoogleCrawlerWeb.Plugs.SetCurrentUser do
  @moduledoc """
    Set the current user to the connection if the user is authenticated.
  """

  import Plug.Conn

  alias GoogleCrawler.Accounts

  def init(_params) do
  end

  def call(conn, _params) do
    current_user_id = get_session(conn, :current_user_id)

    cond do
      current_user = current_user_id && Accounts.get_user(current_user_id) ->
        conn
        |> assign(:current_user, current_user)
        |> assign(:user_signed_in?, true)

      true ->
        conn
        |> assign(:current_user, nil)
        |> assign(:user_signed_in?, false)
    end
  end
end
