#!/usr/bin/env bats

load "$BATS_PATH/load.bash"

# Uncomment to enable stub debugging
# export CURL_STUB_DEBUG=/dev/tty

setup() {
  export BUILDKITE_COMMIT="abc123"
  export BUILDKITE_PLUGIN_SAMSON_DEPLOY_URL="https://example.com"
  export BUILDKITE_BUILD_ID="1"
  export BUILDKITE_BUILD_NUMBER="1"
  export BUILDKITE_BUILD_URL="example.com"
  export BUILDKITE_MESSAGE="message"
  export BUILDKITE_BRANCH="branch"
  export BUILDKITE_SOURCE="source"
  stub mktemp "-d : mkdir -p /tmp/foo ; echo /tmp/foo"
}

@test "curl succeeds" {

  stub curl "* : echo 201 ; echo 'curl_output' > /tmp/foo/samson_output"

  run $PWD/hooks/command

  assert_output --partial "--- Sending Samson webhook"
  assert_output --partial "HTTP code: 201"
  refute_output --partial "curl_output"
  assert_success
  unstub curl
}

@test "curl fails 4xx" {
  expected_payload='{\n "event": "build.finished",\n  "build": {\n    "id": "1",\n    "url": "UNIMPLEMENTED",\n    "web_url": "example.com",\n    "number": 1,\n    "state": "passed",\n    "blocked": false,\n    "message": "message",\n    "commit": "abc123",\n    "branch": "branch",\n    "tag": null,\n    "source": "source",\n    "creator": null,\n    "created_at": "1970-01-01 00:00:00 UTC",\n    "scheduled_at": "1970-01-01 00:00:00 UTC",\n    "started_at": "1970-01-01 00:00:00 UTC",\n    "finished_at": "1970-01-01 00:00:00 UTC",\n    "meta_data": {},\n    "pull_request": null\n  },\n  "pipeline": {},\n  "sender": null\n}'

  stub curl "* : echo 400 ; echo 'curl_output' > /tmp/foo/samson_output"

  run $PWD/hooks/command

  assert_output --partial "--- Sending Samson webhook"
  assert_output --partial "HTTP code: 400"
  assert_output --partial "curl_output"
  assert_failure 1
  unstub curl
}

@test "curl fails 5xx" {
  expected_payload='{\n "event": "build.finished",\n  "build": {\n    "id": "1",\n    "url": "UNIMPLEMENTED",\n    "web_url": "example.com",\n    "number": 1,\n    "state": "passed",\n    "blocked": false,\n    "message": "message",\n    "commit": "abc123",\n    "branch": "branch",\n    "tag": null,\n    "source": "source",\n    "creator": null,\n    "created_at": "1970-01-01 00:00:00 UTC",\n    "scheduled_at": "1970-01-01 00:00:00 UTC",\n    "started_at": "1970-01-01 00:00:00 UTC",\n    "finished_at": "1970-01-01 00:00:00 UTC",\n    "meta_data": {},\n    "pull_request": null\n  },\n  "pipeline": {},\n  "sender": null\n}'

  stub curl "* : echo 500 ; echo 'curl_output' > /tmp/foo/samson_output"

  run $PWD/hooks/command

  assert_output --partial "--- Sending Samson webhook"
  assert_output --partial "HTTP code: 500"
  assert_output --partial "curl_output"
  assert_failure 2
  unstub curl
}
