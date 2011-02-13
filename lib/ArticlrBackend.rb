require 'sinatra'
require 'json'
require_relative '../lib/ContextEngine.rb'

class ArticlrBackend < Sinatra::Base
    set :context_engine, ContextEngine.new

    get '/' do
        { :error => "Please provide data via the /context route" }
    end

   get '/context' do
       latitude = params[:latitude]
       longitude = params[:longitude]
       keywords = params[:keywords]
       latitude = 0 if(latitude.nil?)
       longitude = 0 if(longitude.nil?)

       puts "Request made: -"
       puts "Latitude => #{params[:latitude]}"
       puts "Longitude => #{params[:longitude]}"
       puts "Keywords -> #{params[:keywords]}"
       settings.context_engine.setup_profile( { :latitude => latitude.to_f, :longitude => longitude.to_f }, keywords)
       settings.context_engine.get_context.to_json
   end
end
