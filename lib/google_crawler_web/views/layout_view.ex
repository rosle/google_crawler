defmodule GoogleCrawlerWeb.LayoutView do
  use GoogleCrawlerWeb, :view

  def body_class(conn) do
    "#{module_class_name(conn)} #{action_name(conn)}"
  end

  defp module_class_name(conn) do
    controller_module(conn)
    |> Phoenix.Naming.resource_name("Controller")
    |> String.replace("_", "-")
  end
end
