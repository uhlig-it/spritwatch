# SpritWatch

Part of the course "Web Services", this is an OpenWhisk action that fetches the current fuel price from [Tankerkönig](https://creativecommons.tankerkoenig.de).

# IBM Cloud Functions (OpenWhisk)

This part is based on [openwhisk_docker_samples](https://github.com/gekola/openwhisk_docker_samples/tree/master/ruby_sinatra).

```bash
# Login with SSO
bx login -a api.eu-de.bluemix.net -o "XMLSOA" -s "webservices" --sso

# Login with API key
bx login --apikey ********
bx target -r eu-de -o "XMLSOA" -s "webservices"

alias wsk='bx wsk'

# build and publish
docker login -u suhlig
export IMAGE_NAME=suhlig/spritwatch
docker build -t $IMAGE_NAME . && docker push $IMAGE_NAME

# first time
wsk action create helloRuby --docker $IMAGE_NAME

# later: just update
wsk action update helloRuby --docker $IMAGE_NAME

# invoke
wsk action invoke helloRuby -r -p name happy-person-$RANDOM
```

# Calling the OpenWhisk API

```ruby
response = %x(bx wsk property get --auth)
auth = response.match(%r(whisk auth\s+(\S+)))[1]

response = %x(bx wsk property get --apihost)
api_host = response.match(%r(whisk API host\s+(\S+)))[1]

# WIP Listing actions within a namespace
# curl -u $AUTH https://$API_HOST/api/v1/namespaces/XMLSOA_webservices/actions | jq -r .[].name
if wsk.actions(namespace: 'XMLSOA_webservices').include?('helloRuby')
  # update action
else
  # create action
end
```
