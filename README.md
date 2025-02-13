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

For
[https://sandbox.quotient-familial.numerique.gouv.fr/](https://sandbox.quotient-familial.numerique.gouv.fr/),
use the following credentials:

* `login` : `test`
* `password` : `123`

# Public API

En attendant de faire un swagger correct, voici le minimum vital.

Root url : `https://quotient-familial.numerique.gouv.fr/api`

## GET /collectivites

Liste de toutes les communes utilisant le service.

Response body :

```
[{"name":"Majastres","siret":"21040107100019","code_cog":"04107"}, {"name":"Othertown","siret":"12345678901234","code_cog":"12345"}]
```

## GET /collectivites/:code_cog

Renvoie une commune utilisant le service. Si la commune n'utilise pas le service, renvoie 404 not found.

Response body :

```
{"name":"Majastres","siret":"21040107100019","code_cog":"04107"}
```


