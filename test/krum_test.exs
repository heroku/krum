defmodule Krum.Test do
  use ExUnit.Case
  import Mock
  alias HTTPoison.{Response, Error}

  test "notify_app sends a notification through Telex to the specified app" do
    app_uuid = "1942517b-7035-486c-aca0-414a59e70ccf"
    fake_response = %Response{status_code: 201, body: "{\"id\": \"abcdef\"}"}
    with_mock HTTPoison, [post: fn(_, _, _) -> {:ok, fake_response} end] do
      {:ok, "abcdef"} = Krum.notify_app(app_uuid, "testing", "test body")

      {:ok, endpoint_url} = Application.fetch_env(:krum, :endpoint_url)
      expected_path = Path.join(endpoint_url, "/producer/messages")

      headers = Krum.headers

      args = %{:title => "testing",
               :body  => "test body",
               :target => %{:type => "app", :id => app_uuid}}
      body = Poison.encode! args

      assert called HTTPoison.post(expected_path, body, headers)
    end
  end

  test "notify_app handles non 201 responses" do
    app_uuid = "1942517b-7035-486c-aca0-414a59e70ccf"
    fake_response = %Response{status_code: 200, body: "body"}
    with_mock HTTPoison, [post: fn(_, _, _) -> {:ok, fake_response} end] do
      {:bad_response, "body"} = Krum.notify_app(app_uuid, "testing", "test body")
    end
  end

  test "notify_app handles errors" do
    app_uuid = "1942517b-7035-486c-aca0-414a59e70ccf"
    error = %Error{reason: {:closed, "Something happened"}}
    with_mock HTTPoison, [post: fn(_, _, _) -> {:error, error} end] do
      {:error, error} = Krum.notify_app(app_uuid, "testing", "test body")

      assert error == {:closed, "Something happened"}
    end
  end

  test "notify_user sends a notification through Telex to the specified user" do
    user_uuid = "1942517b-7035-486c-aca0-414a59e70ccf"
    fake_response = %Response{status_code: 201, body: "{\"id\": \"abcdef\"}"}
    with_mock HTTPoison, [post: fn(_, _, _) -> {:ok, fake_response} end] do
      {:ok, "abcdef"} = Krum.notify_user(user_uuid, "testing", "test body")

      {:ok, endpoint_url} = Application.fetch_env(:krum, :endpoint_url)
      expected_path = Path.join(endpoint_url, "/producer/messages")

      headers = Krum.headers

      args = %{:title => "testing",
               :body  => "test body",
               :target => %{:type => "user", :id => user_uuid}}
      body = Poison.encode! args

      assert called HTTPoison.post(expected_path, body, headers)
    end
  end
end
