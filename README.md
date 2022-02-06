# Samson Deploy Buildkite Plugin

[![MIT License](https://img.shields.io/badge/License-MIT-brightgreen.svg)](LICENSE)

[![tests](https://github.com/envato/samson-deploy-buildkite-plugin/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/envato/samson-deploy-buildkite-plugin/actions/workflows/tests.yml)

A [Buildkite plugin](https://buildkite.com/docs/agent/v3/plugins) that lets you send webhooks to Samson.
This is an alternative to using Buildkite Notifications,
which can only be configured by Administrators and hide webhook failures.

## Example

The only required configuration is the Samson URL, available from the Project "Webhook" tab:

```yml
steps:
  - label: ":rocket: Deploy with Samson"
    plugins:
      - envato/samson-deploy#v0.1.2:
          url: "https://example.com/integrations/buildkite/578dc36a28ab49b2998603f0475211c3"
```

## Configuration

### `url`

The Samson webhook URL for your Project.

## Development

To run the tests:

```sh
docker-compose run --rm tests
```

To run the [Buildkite Plugin
Linter](https://github.com/buildkite-plugins/buildkite-plugin-linter):

```sh
docker-compose run --rm lint
```
