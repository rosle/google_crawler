defmodule GoogleCrawlerWeb.Plugs.SetUser do
  import Plug.Conn

  alias GoogleCrawler.Accounts

  def init(_params) do
  end

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Accounts.get_user(user_id) ->
        assign(conn, :user, user)
        assign(conn, :user_signed_in?, true)

      true ->
        assign(conn, :user, nil)
        assign(conn, :user_signed_in?, false)
    end
  end
end
