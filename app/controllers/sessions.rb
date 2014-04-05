get '/' do
  erb :index
end

get '/welcome_back' do
  @user=User.find_by_id(session[:user_id])
  @all_users = User.all
  @all_followings = Following.where(user_id: session[:user_id])
  @all_followers = Following.where(user_name: @user.user_name)
  erb :yourpage
end

get '/user/:user' do
  if params[:user] != nil
    @user=User.find_by_user_name(params[:user])
    @all_users = User.all
    erb :otherspage
  end
end

post '/welcome_back' do
  @user = User.find_by_user_name(params[:user_name])
  if User.authenticate(params[:user_name], params[:password])
    session[:user_id]=@user.id
    @all_users = User.all
    @all_followings = Following.where(user_id: session[:user_id])
    @all_followers = Following.where(user_name: @user.user_name)
    erb :yourpage
  else
    @fail = "Your password or username was incorrect. Try again"
    erb :index
  end
end

post '/register' do
  @user = User.create(full_name: params[:full_name], user_name: params[:user_name],  email: params[:email], password: params[:password] )
  if @user.id == nil
    @fail = "You can't register with that info. Try again"
    erb :index
  else
    session[:user_id]=@user.id
    @all_users = User.all
    @all_users
    erb :yourpage
  end
end

post '/tweet/new' do
  @tweet = Tweet.create(input: params[:tweet], user_id: session[:user_id])
  @user = User.find_by_id(session[:user_id])
  if @tweet[:id] == nil
    @fail = "That tweet was too terrible"
  end
  @all_users = User.all
  @user.tweets
  erb :yourpage
end

post '/followers/:follower' do
  @user=User.where(id: session[:user_id])
  @user = @user[0]
  @all_users = User.all
  User.find_by_id(session[:user_id])
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

get '/newsfeed' do
  if session[:user_id] != nil
    @user = User.find_by_id(session[:user_id])
    @all_followings = Following.where(user_id: session[:user_id])
    @tweet = []
    if @all_followings != nil
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

get '/logout' do
  session[:user_id]=nil
  redirect ('/')
end
