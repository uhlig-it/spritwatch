# SpritWatch

[![Build Status](https://travis-ci.org/uhlig-it/spritwatch.svg?branch=master)](https://travis-ci.org/uhlig-it/spritwatch)

Part of the course "Web Services", this is an OpenWhisk action that fetches the current fuel price from [Tankerkönig](https://creativecommons.tankerkoenig.de).

# IBM Cloud Functions (OpenWhisk)

This part is based on [openwhisk_docker_samples](https://github.com/gekola/openwhisk_docker_samples/tree/master/ruby_sinatra).

## Install CLI

```bash
# Install bx, see https://console.bluemix.net/openwhisk/learn/cli

# Linux
curl -fsSL https://clis.ng.bluemix.net/install/linux | sh

# macOS
brew install jthomas/tools/wsk

# Install wsk plugin
bx plugin install Cloud-Functions -r Bluemix
alias wsk='bx wsk'
```

## Login

```bash
# Login with SSO
bx login -a api.eu-de.bluemix.net -o "XMLSOA" -s "webservices" --sso

# Login with API key
bx login --apikey ********
bx target -r eu-de -o "XMLSOA" -s "webservices"
```

## Setup InfluxDB database and -user

```bash
influx \
  -host ${influxdb_host?"Missing variable"} \
  -ssl \
  -port ${influxdb_port?"Missing variable"} \
  -username ${influxdb_admin_user?"Missing variable"} \
  -password ${influxdb_admin_password?"Missing variable"} \
  -execute "$(cat <<END_HEREDOC
    CREATE DATABASE ${spritwatch_database?"Missing variable"};
    CREATE USER ${spritwatch_user?"Missing variable"} WITH PASSWORD '${spritwatch_password?"Missing variable"}';
    GRANT ALL ON ${spritwatch_database?"Missing variable"} TO ${spritwatch_user?"Missing variable"};
END_HEREDOC
)"
```

## Build and Publish

```bash
docker login -u suhlig
export IMAGE_NAME=suhlig/spritwatch
docker build -t "$IMAGE_NAME" . && docker push "$IMAGE_NAME"

# first time setup: use update as below, and replace 'update' with 'create'

# Update the action
wsk action update spritwatch \
  --docker "$IMAGE_NAME" \
  -p TANKERKOENIG_API_KEY "$TANKERKOENIG_API_KEY" \
  -p influxdb_host "$influxdb_host" \
  -p influxdb_port "$influxdb_port" \
  -p spritwatch_database "$spritwatch_database" \
  -p spritwatch_user "$spritwatch_user" \
  -p spritwatch_password "$spritwatch_password"

# invoke
wsk action invoke spritwatch -r -p ids 95d000e0-48a3-41e1-907f-e32dc9d58525,51d4b53f-a095-1aa0-e100-80009459e03a
```

## Development

1. Start the HTTP server that implements the OpenWhisk action:

   ```bash
   rerun bundle exec rackup
   ```

1. Invoke the action via HTTP:

   ```bash
   jq -n '{
    "value": {
      "ids": "870efffb-676b-4301-854e-c80e93c3e3ef,51d4b425-a095-1aa0-e100-80009459e03a,51d4b49c-a095-1aa0-e100-80009459e03a",
      "TANKERKOENIG_API_KEY": env.TANKERKOENIG_API_KEY,
      "influxdb_host": env.influxdb_host,
      "influxdb_port": env.influxdb_port,
      "spritwatch_database": env.spritwatch_database,
      "spritwatch_user": env.spritwatch_user,
      "spritwatch_password": env.spritwatch_password
    }
   }' | curl -H "Content-Type: application/json" -X POST -d @- localhost:8080/run
   ```

# Calling the OpenWhisk API

```ruby
response = %x(bx wsk property get --auth)
auth = response.match(%r(whisk auth\s+(\S+)))[1]

response = %x(bx wsk property get --apihost)
api_host = response.match(%r(whisk API host\s+(\S+)))[1]

# WIP Listing actions within a namespace
# curl -u $AUTH https://$API_HOST/api/v1/namespaces/XMLSOA_webservices/actions | jq -r .[].name
if wsk.actions(namespace: 'XMLSOA_webservices').include?('spritwatch')
  # update action
else
  # create action
end
```
