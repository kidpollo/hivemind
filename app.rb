require 'sinatra/base'
require 'sinatra/content_for2'
require 'slim'
require 'coffee_script'
require 'sprockets'
require 'omniauth-github'

# stuff in lib
require './lib/sprockets_sinatra_middleware'

module Hivemind
  class App < Sinatra::Base

    use Rack::Session::Cookie
    #use OmniAuth::Strategies::Developer
    
    use OmniAuth::Builder do
      provider :github, '9c03fbf168674054ac8c', '880ef7f8580b85d64bc8a805eabca546cc2d47da'
    end

    helpers Sinatra::ContentFor2

    set :root, File.dirname(__FILE__)  
  
    use ::SprocketsSinatraMiddleware, :root => settings.root, :path => 'assets' 
  
    get "/" do
      slim :index
    end

    %w(get post).each do |method|
      send(method, "/auth/:provider/callback") do
        env['omniauth.auth'] # => OmniAuth::AuthHash
      end
    end

    get '/auth/failure' do
      #flash[:notice] = params[:message] # if using sinatra-flash or rack-flash
      redirect '/'
    end
    
  end
end
