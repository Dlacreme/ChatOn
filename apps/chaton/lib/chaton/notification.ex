defmodule Chaton.Notification do
  @moduledoc """
  Notification is basically a Message with all the required metadata for client to process the message
  It is the last step of the `send` pipeline for messages.

  Notification is then either sent to client if the recipient is connected
    or stored in Database until the recipient connects
  """
  defstruct from: nil, to: nil, context: nil, content: nil

  defimpl Jason.Encoder, for: Chaton.Notification do
    def encode(value, opts) do
      Jason.Encode.map(Map.take(value, [:from, :to, :context, :content]), opts)
    end
  end
end
