# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Rails 8 application for French local authorities (collectivités) to securely collect family quotient data (quotient familial) from citizens using FranceConnect authentication. The service retrieves quotient familial data from CAF or MSA and transmits it to local authorities via HubEE.

Ruby version: 3.4.1
Rails version: 8.0.2

## Development Commands

### Setup
```bash
# Initial setup - requires credentials keys (config/master.key, config/credentials/development.key, config/credentials/test.key)
./bin/install.sh

# Install dependencies
bundle install

# Start server
rails s
# or
bin/dev

# Access at localhost:3000
```

### Testing
```bash
# Run all RSpec tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/path/to/file_spec.rb

# Run Cucumber features
bundle exec cucumber

# Auto-run tests on file changes
bundle exec guard
```

### Linting
```bash
# Auto-correct with RuboCop
bundle exec rubocop -A
```

### Database
```bash
# Load schema (test environment)
bin/rails db:schema:load RAILS_ENV=test

# Create migration
bin/rails generate migration MigrationName

# Run migrations
bin/rails db:migrate
```

## Architecture

### Service Orchestration Pattern

The application uses the **Interactor gem** for service orchestration with a two-tier pattern:

- **Interactors** (`app/interactors/`): Single-purpose service objects that perform one specific action
- **Organizers** (`app/organizers/`): Orchestrate multiple interactors in sequence

All interactors inherit from `BaseInteractor` and organizers from `BaseOrganizer`.

Example flow:
```ruby
StoreQuotientFamilial < BaseOrganizer
  organize UploadQuotientFamilialToHubEE, CreateShipment

UploadQuotientFamilialToHubEE < BaseOrganizer
  organize PrepareQuotientFamilialHubEEFolder,
           HubEE::PrepareAttachments,
           HubEE::CreateFolder,
           HubEE::UploadAttachments,
           HubEE::MarkFolderComplete,
           HubEE::CleanAttachments
```

When creating new business logic, use interactors for single actions and organizers to chain multiple interactors together.

### External API Integration

External APIs are implemented in `lib/` with consistent patterns:

- **API Particulier** (`lib/api_particulier/`): Retrieves quotient familial data from CAF/MSA
- **HubEE** (`lib/hubee/`): Transmits data to local authorities
  - `lib/hubee/api.rb`: Main API client
  - `lib/hubee/admin_api.rb`: Administrative operations
  - `lib/hubee/auth.rb`: OAuth2 authentication
- **INSEE Sirene** (`lib/insee_sirene/`): Organization data validation

Each API module follows a `Base` -> `Auth` -> `Api` pattern with Faraday clients.

### Configuration

Application settings use the `config` gem with environment-specific YAML files:
- Base: `config/settings.yml`
- Environment-specific: `config/settings/development.yml`, `config/settings/production.yml`

Sensitive credentials are encrypted in `config/credentials/` using Rails encrypted credentials.

Access settings via `Settings.api_particulier.base_url`, `Settings.france_connect.host`, etc.

### Authentication & Sessions

- **FranceConnect**: OAuth/OpenID Connect integration using `omniauth_openid_connect`
- Sessions managed via `activerecord-session_store` (database-backed)
- User identity stored in `pivot_identity` (FranceConnect pivot identity)
- Current user/collectivity tracked via `app/models/current.rb` (Rails CurrentAttributes)

### Data Models

Core models:
- `Collectivity`: Local authority organizations (stored by SIRET, code_cog)
- `Shipment`: User data submission record
- `ShipmentData`: Associated quotient familial data
- `Organization`: HubEE organization entity
- `Hubee::Folder`, `Hubee::Attachment`, `Hubee::Notification`: HubEE integration models
- `User`: FranceConnect authenticated users

### Background Jobs

Uses **GoodJob** adapter for ActiveJob with PostgreSQL-backed queue.

Access GoodJob dashboard at `/good_job` (protected by credentials in production).

### API

Public REST API documented in `docs/swagger.yaml`:
- `GET /api/collectivites`: List available collectivities
- `GET /api/collectivites/{code_cog}`: Get specific collectivity
- `POST /api/datapass/webhook`: DataPass webhook for provisioning

### Testing

- **RSpec**: Unit and integration tests (`spec/`)
- **Cucumber**: Acceptance tests (`features/`)
- **FactoryBot**: Test data factories
- **WebMock**: HTTP request stubbing (required - external connections disabled)
- **SimpleCov**: Code coverage tracking
- **Guard**: Auto-run tests on file changes

When writing tests, always stub external API calls with WebMock.

## Sandbox Access

Sandbox environment at https://sandbox.quotient-familial.services.api.gouv.fr/
- Login: `test`
- Password: `123`

## Remote Server Tools

For authorized developers:
```bash
bin/explore-remote-logs [ENV]  # less on logs
bin/remote-console [ENV]       # rails console
bin/stream-remote-logs [ENV]   # tail -f on logs
```
