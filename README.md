# README

## Install project

### Database setup

Ask a dev for the 3 keys necessary to decrypt the secrets :

- `config/master.key` (optional for dev)
- `config/credentials/development.key`
- `config/credentials/test.key`

Then execute:

```sh
./bin/install.sh
```

```sh
bundle install
rails s
```

Then you can visit `localhost:3000`

# Run the tests

```sh
bundle exec rspec
bundle exec cucumber
```

You can also use Guard to run the test of the last saved file :

```sh
bundle exec guard
```

# Linter autocorrect

```sh
bundle exec rubocop -A
```

