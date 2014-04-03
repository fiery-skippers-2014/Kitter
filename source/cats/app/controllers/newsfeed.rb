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



