get '/' do
  if session[:user_id] != nil # for users already logged in
    redirect "/#{User.find(session[:user_id]).user_name}"
  else
    erb :index
  end
end

post '/welcome_back' do
  @user = User.find_by_user_name(params[:user_name])
  if User.authenticate(params[:user_name], params[:password])
    session[:user_id]=@user.id
    @all_users = User.all
    @all_users.delete(session[:user_id])
    @all_followings = Following.find_by_user_id(session[:user_id])
    @all_follower = Follower.find_by_user_id(session[:user_id])
    erb :yourpage
  else
    @fail = "Your password or username was incorrect. Try again"
    erb :index
  end
end

post '/register' do
  @user = User.create(full_name: params[:full_name], user_name: params[:user_name],  password: params[:password] )
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
 if Tweet.create(text: params[:tweet], user_id: sessions[:user_id]).valid?
  redirect '/:yourpage'
else
  @fail = "That tweet was too terrible"
  erb :yourpage
 end
end

post '/followers/new' do
if Follower.create(user_name: params[:follower], user_id: sessions[:user_id]).valid?
  redirect '/:yourpage'
else
  @fail = "That tweet was too terrible"
  erb :yourpage
 end
end

get '/news_feed' do
  # User logged in
  if session[:user_id] != nil
    @user = User.find_by_id(session[:user_id])
    erb: news_feed

  # User not logged in
  else
    @fail = "You are not logged in! Please log in."
    erb: index
  end

end



get '/logout' do
  session[:user_id]=nil
  redirect ('/')
end


# Helper methods

# def current_user(property, query)
#   User.where("#{property} = ?", query).first
# end

# def valid_user?(params_password, actual_password) # BUGBUG
#   user = User.find_by_user_name(user_name)
#       if user != nil
#   params_password == actual_password
# end


# <!-- List of people following you?
# <% #@all_followings.each do |person| %>
#   <%= person.user_name%>
#   <br>
# <% #end %>

# List of people you follow?
# <% #@all_followers.each do |person| %>
#   <%= person.user_name%>
#   <br>
# <% #end %> -->
