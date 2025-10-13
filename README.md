# README

Pour l'API, consulter le [swagger](/docs/swagger.yaml)

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

## Tools for remote server

You have to be added on servers to use these binaries.

Usage: `bin/script [ENV]`

```
# `less` on logs
bin/explore-remote-logs
# remote rails console
bin/remote-console
# `tail -f` on logs
bin/stream-remote-logs
```

## Connect on sandbox

For [https://sandbox.quotient-familial.services.api.gouv.fr/](https://sandbox.quotient-familial.services.api.gouv.fr/),
use the following credentials:

* `login` : `test`
* `password` : `123`

# Public API

Voir [le fichier swagger](/docs/swagger.yaml)

# Guide d'utilisation pour les communes sans éditeur

> https://docs.numerique.gouv.fr/docs/ff4c7a80-1acb-4d52-b65e-37c0625a2798/


