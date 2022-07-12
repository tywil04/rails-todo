Rails Todo App Using Turbo Streams

This application has a crude form of WebAuthn as testing. As of current, no error messages are shown.

To run this project:
```
git clone https://github.com/tywil04/rails-todo.git
cd rails-todo
bundle              # Installs required gems
rails db:migrate    # Creates the required tables in the database
bin/dev             # Runs the development server on localhost:3000
```

webauthn-ruby is the gem used to help get WebAuthn enabled