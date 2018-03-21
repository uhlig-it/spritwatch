require 'json'
require 'sinatra/base'

class App < Sinatra::Base
  set :port, 8080

  post '/init' do
    warn "Initializing with #{request.params}"
  end

  post '/run' do
    params = JSON.parse(request.body.read)
    name = params.dig('value', 'name') || 'world'
    content_type :json
    JSON.dump({'result' => {'msg' => "Hello, #{name}"}})
  end
end

App.run!
