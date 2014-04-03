post '/welcome_back' do
  @user = User.find_by_user_name(params[:user_name])
  if User.authenticate(params[:user_name], params[:password])
    session[:user_id]=@user.id
    erb :your_page
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
    erb :your_page
  end
end

