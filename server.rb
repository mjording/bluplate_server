require 'rubygems'
require 'sinatra'
require 'erb'
require 'haml'
require File.join(File.dirname(__FILE__), 'tweet_store')



get '/' do
  erb :index
end

# get '/latest' do
#   # We're using a Javascript variable to keep track of the time the latest
#   # tweet was received, so we can request only newer tweets here. Might want
#   # to consider using Last-Modified HTTP header as a slightly cleaner
#   # solution (but requires more jQuery code).
#   @tweets = STORE.tweets(5, (params[:since] || 0).to_i)
#   @tweet_class = 'latest'  # So we can hide and animate
#   haml :tweets, :layout => false
# end
# 
# post '/usertweets' do
#   content_type :json
#   address = params[:username]
#   
# end
