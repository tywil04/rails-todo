Rails Todo App Using Turbo Streams

This application has a crude form of WebAuthn as testing

To run this project:
```
git clone https://github.com/tywil04/rails-todo.git
cd rails-todo
bundle # Installs required gems
rails db:migrate # Creates the required tables in the database
bin/dev # Runs the development server on localhost:3000
```

When testing WebAuthn without a domain nor certificate will only work on Chromium based browsers (Brave, Edge, Chrome) via `localhost`. In chrome `localhost` is a `potentially trustworthy` domain so it is allowed to access the required APIs for WebAuthn. `localhost` is also a valid domain that can be set for the relying party id. `127.0.0.1` does not work for this reason, its not a valid domain you can set for the relying party id.