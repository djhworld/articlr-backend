require 'sinatra'
require 'json'
require_relative '../lib/ContextEngine.rb'

class ArticlrBackend < Sinatra::Base
    set :context_engine, ContextEngine.new

    get '/' do
        puts "print"
    end

   get '/context' do
       puts "Request made: -"
       puts "Latitude => #{params[:latitude]}"
       puts "Longitude => #{params[:longitude]}"
       puts "Keywords -> #{params[:keywords]}"

       settings.context_engine.setup_profile( { :latitude => params[:latitude].to_f, :longitude => params[:longitude].to_f }, params[:keywords])
       settings.context_engine.get_context.to_json
   end
end
