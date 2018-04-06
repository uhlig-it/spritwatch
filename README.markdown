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

## Build and Publish

```bash
docker login -u suhlig
export IMAGE_NAME=suhlig/spritwatch
docker build -t $IMAGE_NAME . && docker push $IMAGE_NAME

# first time
wsk action create spritwatch --docker $IMAGE_NAME -p TANKERKOENIG_API_KEY $TANKERKOENIG_API_KEY

# later: just update
wsk action update spritwatch --docker $IMAGE_NAME -p TANKERKOENIG_API_KEY $TANKERKOENIG_API_KEY

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
   curl -H "Content-Type: application/json" -X POST -d '{"value": {"ids": "4429a7d9-fb2d-4c29-8cfe-2ca90323f9f8", "TANKERKOENIG_API_KEY": "00000000-0000-0000-0000-000000000002"}}' localhost:8080/run
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
