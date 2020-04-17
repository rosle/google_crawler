defmodule GoogleCrawlerWeb.Router do
  use GoogleCrawlerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug GoogleCrawlerWeb.Plugs.SetCurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Authentication routes
  scope "/", GoogleCrawlerWeb do
    pipe_through [:browser, GoogleCrawlerWeb.Plugs.SkipAfterAuth]

    resources "/registrations", RegistrationController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :create]
  end

  # Protected routes
  scope "/", GoogleCrawlerWeb do
    pipe_through [:browser, GoogleCrawlerWeb.Plugs.EnsureAuth]

    resources "/sessions", SessionController, only: [:delete]
    resources "/upload", UploadController, only: [:create]

    get "/", DashboardController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", GoogleCrawlerWeb do
  #   pipe_through :api
  # end
end
