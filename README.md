# Chat On

Cool chat system written in Elixir.

One instance per consumer. You can add an admin using a single email and password through CLI (check seeds.exs)

## Consumer Flow
 1. Consumer back-end can create a new user and attach any meta data via the admin API (optional)
 2. Consumer back-end can authenticate a user or a guest on the system via the admin API. It will generate an authentication token returned by the API
 3. Consumer front-end can open a socket on the system and use the authentication token to start the user/guest session
 4. Once successfully authenticated, socket will receive any unread notifications and then start listen for incoming or outgoing messages

## Applications
 - Administration panel (/apps/chaton_web): CRUD on user roles and enable/disable features
 - Chat server: websocket for clients to connect to
 - WebRTC server: WebRTC system to allow clients to create WebRTC sessions

## Features
 - [ ] Admin Panel
 - [x] Roles & Authentication system
 - [ ] Notifications system
 - [ ] One to one chat
 - [ ] One to many chat (chat room)
 - [ ] Message formatting (tag people, emojis, etc...)
 - [ ] WebRTC support

## Contributes

### Setup
  * Elixir
  * Postgresql

### Env Variables
| Name    | Description                          |
| ------- | ------------------------------------ |
| API_KEY | Api key for the current organization |

### Web Server
To start the Phoenix Web Server (admin app):
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

### Testing

Make sure all the test pass:
  * `mix test`
  * `mix test.watch`

## Deployment

*Not ready yet for production*
