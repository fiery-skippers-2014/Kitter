get '/' do
  erb :index
end

get '/logout' do
  session[:user_id]=nil
  redirect ('/')
end