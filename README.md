# Chat On

Cool chat system written in Elixir.

## Applications
 - Administration panel (/apps/chaton_web): CRUD on user roles and enable/disable features
 - Chat server: websocket for clients to connect to
 - WebRTC server: WebRTC system to allow clients to create WebRTC sessions

## Features
 - [ ] Admin Panel
 - [ ] Roles & Authentication system
 - [ ] One to one chat
 - [ ] One to many chat (chat room)
 - [ ] Message formatting (tag people, emojis, etc...)
 - [ ] WebRTC support

## Contributes

### Setup
  * Elixir
  * Postgresql

### Web Server
To start the Phoenix Web Server (admin app):
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

### Testing

Make sure all the test pass:
  * `mix test`

## Deployment

*Not ready yet for production*
