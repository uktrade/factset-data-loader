## Factset data loader

Fetch subscriptions using the factset data loader and write them to a directory. For eventual processing by data flow.

### Get started

1. `cp sample.env .env`
2. Update `.env` with username, device id and comma separated list of bundles to sync (no spaces between comma separated items).
3. `docker-compose up`
