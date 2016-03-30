# Krum

Provides a simple API to send notifications through [Telex](https://github.com/heroku/telex).

## Installation

## Usage

Currently, the krum application comes with a configuration that pulls the remote Telex server from the TELEX_URL environment variable.

You'll need the app uuid to send messages to a specific app.
```
iex(1)> Krum.notify_app("3a5c6391-fada-4f01-bbfc-ababababab", "testing", "testing")
{:ok, "abc123-c3e5-4c67-b119-17edef879cd5"}
```
The return code can also be {:error, reason} or {:badresponse, response} if the Telex system returns a non 201 response.
