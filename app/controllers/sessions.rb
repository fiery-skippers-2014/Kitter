get '/' do
  # if sess        ion[:user_id] != nil # for users already logged in
  #   redirect "/#{User.find(session[:user_id]).user_name}"
  # else
    erb :index
end

post '/welcome_back' do
  @user = User.find_by_user_name(params[:user_name])
  if User.authenticate(params[:user_name], params[:password])
    session[:user_id]=@user.id
    @all_users = User.all
    @all_users.delete(session[:user_id])
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
    @all_users.delete(session[:user_id])
    erb :yourpage
  end
end

post '/tweet/new' do
@tweet=Tweet.create(input: params[:tweet], user_id: session[:user_id])
p @tweet
@user=User.find_by_id(session[:user_id])
  if @tweet[:id] == nil
    @fail = "That tweet was too terrible"
  end
  @all_users = User.all
  @user.tweets
  erb :yourpage
end

post '/followers/new' do
if authenticate(params[:follower])
  Following.create(user_name: params[:follower], user_id: session[:user_id])
  @user=User.find_by_id(session[:user_id])
  @all_users = User.all
  @all_followings = Following.where(user_id: session[:user_id])
  @all_followers = Following.where(user_name: @user.user_name)
  @all_followers.map! do |record|
     User.find_by_id(record.user_id).user_name
  end
  erb :yourpage
else
  @fail = "That tweet was too terrible"
  erb :yourpage
 end
end

get '/newsfeed' do
  # User logged in
  if session[:user_id] != nil
    @user = User.find_by_id(session[:user_id])
    @all_followings = Following.where(user_id: session[:user_id])

    @tweet = []

    @all_followings.each do |person|
      @tweet << person.tweets
    end

    @tweet.sort_by! do |tweet|
      tweet.created_at
    end

    erb :newsfeed

  # User not logged in
  else
    @fail = "You are not logged in! Please log in."
    erb :index
  end

end

get '/logout' do
  session[:user_id]=nil
  redirect ('/')
end

