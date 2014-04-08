get '/' do
  erb :index
end

get '/welcome_back' do #CR not a RESTful route
  @user=User.find_by_id(session[:user_id])
  #CR create a helper method - current_user
  @all_users = User.all
  @all_followings = Following.where(user_id: session[:user_id])
  #CR use your helper method and AR relations
  @all_followers = Following.where(user_name: @user.user_name)

  erb :yourpage
end

get '/user/:user' do #CR not a RESTful route
  if params[:user] != nil  #CR what happens if :user is nil? also name your form fields after your DB fields
    @user=User.find_by_user_name(params[:user])
    #CR create a current_user helper method.
    @all_users = User.all
    erb :otherspage
  end
end

post '/welcome_back' do #CR not a RESTful route
  @user = User.find_by_user_name(params[:user_name]) #CR not until after athentic
  if User.authenticate(params[:user_name], params[:password])
    session[:user_id]=@user.id
    @all_users = User.all
    @all_followings = Following.where(user_id: session[:user_id])
    #CR create a model method for this.
    @all_followers = Following.where(user_name: @user.user_name)
    erb :yourpage
  else
    @fail = "Your password or username was incorrect. Try again"
    erb :index
  end
end

post '/register' do #CR not a RESTful route
  #CR should be able to do User.create(params)
  @user = User.create(full_name: params[:full_name], user_name: params[:user_name],  email: params[:email], password: params[:password] )
  if @user.id == nil
    @fail = "You can't register with that info. Try again"
    erb :index
  else
    session[:user_id]=@user.id
    @all_users = User.all
    @all_users #CR? Not needed.
    erb :yourpage
  end
end

post '/tweet/new' do #CR not a RESTful route
  #CR use AR and your helper method : current_user.tweets.create(params)

  # @tweet = Tweet.create(input: params[:tweet], user_id: session[:user_id])
  # @user = User.find_by_id(session[:user_id])
  # if @tweet[:id] == nil
  #   @fail = "That tweet was too terrible"
  # end
  # @all_users = User.all
  # @user.tweets
  # erb :yourpage

  #CR see refactor.
  @tweet = current_user.tweets.create(params)
  # @tweet = Tweet.create(input: params[:tweet], user_id: session[:user_id])
  # @user = User.find_by_id(session[:user_id])
  unless @tweet.valid?
    @fail = "That tweet was too terrible"
  end
  @all_users = User.all
  # @user.tweets
  erb :yourpage


end

post '/followers/:follower' do #CR not a RESTful route
  @user=User.where(id: session[:user_id]) #CR use find or where().first
  @user = @user[0]
  @all_users = User.all
  User.find_by_id(session[:user_id])
  #CR Way too much logic for your controller! use model and helper methods to DRY up code.
  if User.find_by_id(session[:user_id]).user_name != params[:follower] && authenticate(params[:follower])
    Following.create(user_name: params[:follower], user_id: session[:user_id])
    @all_followings = Following.where(user_id: session[:user_id])
    @all_followers = Following.where(user_name: @user.user_name)
    @all_followers.map! do |record|
       User.find_by_id(record.user_id).user_name
    end
    redirect('/welcome_back')
  else
    @fail = "You can't follow that person"
    erb :yourpage
  end
end

get '/newsfeed' do #CR not a RESTful route
  if session[:user_id] != nil #CR if current_user
    @user = User.find_by_id(session[:user_id])
    @all_followings = Following.where(user_id: session[:user_id])
    @tweet = []
    if @all_followings != nil  #CR - refactor! where returns [] if not found so you can still call .each on it.
      @all_followings.each do |follower|
        @tweet << User.find_by_user_name(follower.user_name).tweets
      end
    end
    if @tweet.count > 0
      @tweet.flatten!.sort_by! do |tweet|
        tweet.created_at
      end
    end
    erb :newsfeed
  else
    @fail = "You are not logged in! Please log in."
    erb :index
  end
end

get '/logout' do #CR not a RESTful route
  session[:user_id]=nil
  redirect ('/')
end
