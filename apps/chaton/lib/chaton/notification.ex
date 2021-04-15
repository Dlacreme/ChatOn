defmodule Chaton.Notification do
  @moduledoc """
  Notification are core of Chaton Messaging.
  It is basically a Message with all the required metadata for client to process the message

  Notification is the outgoing pipeline for messages. Chaton.Chat.send_message return a Notification.

  Notification is then either sent to client if the recipient is connected
    or stored in Database and wait for user to connect to send the Notification and clear the item in DB
  """
  defstruct from: nil, to: nil, context: nil, content: nil
end
