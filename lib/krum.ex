defmodule Krum do
  alias HTTPoison.{Response, Error}

  @producer_path "/producer/messages"

  @spec notify_app(String.t, String.t, String.t) :: {:ok, String.t} | {:error, String.t}
  def notify_app(app_uuid, title, body) do
    make_message("app", app_uuid, title, body)
    |> encode_message
    |> make_request
  end

  @spec notify_user(String.t, String.t, String.t) :: {:ok, String.t} | {:error, String.t}
  def notify_user(user_uuid, title, body) do
    make_message("user", user_uuid, title, body)
    |> encode_message
    |> make_request
  end

  defp make_request(body) do
    HTTPoison.post(endpoint, body, headers)
    |> handle_response
  end

  @spec endpoint :: String.t
  defp endpoint do
    Path.join(Application.fetch_env!(:krum, :endpoint_url), @producer_path)
  end

  @spec handle_response({:ok, Response.t}) :: {:ok, String.t} | {:bad_response, String.t} | {:error, any}
  defp handle_response({:ok, %Response{status_code: 201, body: body}}) do
    {:ok, Poison.decode!(body) |> Map.get("id")}
  end

  defp handle_response({:ok, %Response{body: body}}) do
    {:bad_response, body}
  end

  defp handle_response({:error, %Error{reason: reason}}) do
    {:error, reason}
  end

  @spec headers :: [{String.t, String.t}]
  def headers do
    [{"Content-Type", "application/json"},
     {"User-Agent", user_agent}]
  end

  @spec user_agent :: String.t
  defp user_agent do
    "krum" <> "/" <> version
  end

  @spec encode_message(%{atom => String.t}) :: String.t
  defp encode_message(message) do
    Poison.encode! message
  end

  @spec make_message(String.t, String.t, String.t, String.t) :: %{atom => String.t}
  defp make_message(type, uuid, title, body) do
    %{:title => title,
      :body => body,
      :target => %{:type => type, :id => uuid}}
  end

  @spec version :: String.t
  defp version do
    :erlang.list_to_binary(Application.spec(:krum, :vsn))
  end
end
