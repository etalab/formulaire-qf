# README

## Install project

### Database setup
Ask a dev for the 3 keys necessary to decrypt the secrets :
- `config/master.key`
- `config/credentials/development.key`
- `config/credentials/test.key`


Get the credentials for the db like this (we'll call them `theuser` and `thepassword`)

```sh
rails credentials:show
```

Then enter the psql command line

```sh
sudo su - postgres

psql
```

Create the superuser with the credentials you got before

```SQL
> CREATE ROLE theuser WITH SUPERUSER CREATEDB LOGIN PASSWORD 'thepassword';
```

Then exit the psql command line, and run

```sh
rails db:setup
```

### Run the dev server

```sh
bundle install
rails s
```

Then you can visit `localhost:3000`

# Run the tests

```sh
rspec
```