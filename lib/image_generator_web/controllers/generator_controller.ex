defmodule ImageGeneratorWeb.GeneratorController do
  use ImageGeneratorWeb, :controller

  def index(conn, _params) do
     render(conn, :index)
  end

  def show(conn, %{"message" => message}) do
    render(conn, :show, message: message)
  end
end
