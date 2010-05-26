require 'rubygems'
require 'sinatra'
require 'erb'
require 'settingslogic'
require 'twitter_oauth'
require 'bluplate'
require 'configuration'
#require File.join(File.dirname(__FILE__), 'tweet_store')


class Server < Sinatra::Base
  @@config = Configuration
  set :sessions, true
  
  before do
    next if request.path_info =~ /ping$/
    @user = session[:user]
    @client = TwitterOAuth::Client.new(
      :consumer_key =>  @@config.authorization.consumer_key,
      :consumer_secret =>  @@config.authorization.consumer_secret,
      :token => session[:access_token],
      :secret => session[:secret_token]
    )
    @rate_limit_status = @client.rate_limit_status
  end
  get '/' do
    redirect '/profile' if @user
    erb :login
  end
  
  get '/dashboard' do
    begin
       @access_token = @client.authorize(
         session[:request_token],
         session[:request_token_secret],
         :oauth_verifier => params[:oauth_verifier]
       )
     rescue OAuth::Unauthorized
     end
     if @client.authorized?
         # Storing the access tokens so we don't have to go back to Twitter again
         # in this session. In a larger app you would probably persist these details somewhere.
         session[:access_token] = @access_token.token
         session[:secret_token] = @access_token.secret
         session[:user] = true
         
         #update or record user in mongo
         #no need to store key for mongo stored user as we should always have @client.info['screen_name']
         @user = Bluplate::User.find_by_email("#{@client.info[:user_id]}@twitter.com") ? Bluplate::User.find_by_email("#{@client.info[:user_id]}test@twitter.com") : Bluplate::User.create(:userid => "#{@client.info[:user_id]}@twitter.com")
         #@s = mongo["users"].find("name" => @client.info['screen_name']).first
         #@account = s && s.class == OrderedHash ? Account.new(s) : Account.new(:name => @client.info['screen_name'])
         #@account.last_login_at = Time.now
         #@account.inbox ||= []
         #@account.work_stream ||= []
         #@account.contacts ||= []
         #@account.friends = @client.all_friends
         #mongo["users"].update({"name" => @client.info['screen_name']}, @account.to_hash, {:upsert => true})
         
         #take the user to the profile page
         redirect '/profile'
       else
         #user is not authorized
         redirect '/'
       end
  
  end
  
  get '/login' do
   
    request_token = @client.request_token(:oauth_callback =>  @@config.authorization.callback_url)
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    redirect request_token.authorize_url  
  
  end
  get '/profile' do
    @s = @client.all_friends
    #@account ||= Account.new mongo["users"].find("name" => @client.info['screen_name']).first
    erb :profile
  end
  get '/ping' do
    'pong'
  end
  get '/disconnect' do
    session[:user] = nil
    session[:request_token] = nil
    session[:request_token_secret] = nil
    session[:access_token] = nil
    session[:secret_token] = nil
    redirect '/'
  end
  post '/inbox/add' do
    #@account ||= Account.new mongo["users"].find("name" => @client.info['screen_name']).first
    content_type :json
    my_hash_object = JSON.parse(request.body.read) 
    #@account.inbox << my_hash_object
    #mongo["users"].update({"name" => @client.info['screen_name']}, @account.to_hash, {:upsert => true})
    
    my_hash_object.to_json
  end
end