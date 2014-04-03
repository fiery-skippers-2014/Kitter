enable :sessions

get '/' do
  if session[:user_id] != nil # for users already logged in
    redirect "/#{User.find(session[:user_id]).user_name}"
  else
    erb :index
  end
end

post '/' do
  @current_user = current_user("user_name", params[:user_name])
  if valid_user?(params[:password], @current_user.password)
    redirect '/:your_page'
  else
    redirect '/'
  end
end

get '/:user_name' do
  # render appropriate view

  erb :your_page
end

get '/logout' do
  session[:user_id]=nil
  redirect ('/')
end


# Helper methods

def current_user(property, query)
  User.where("#{property} = ?", query).first
end

def valid_user?(params_password, actual_password) # BUGBUG
  # needs to also check passed in username
  params_password == actual_password
end