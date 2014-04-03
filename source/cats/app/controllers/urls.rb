post '/urls' do
  # Invalid URL
  unless Url.create(longurl: params[:longurl], user_id: session[:user_id]).valid?
    @fail = "That URL wasn't valid, try again..."
    erb :index
  end

  # Display URL if guest
  if session[:user_id] == nil
    @url = Url.last
    erb :guest_page

  # Display URLs if logged in on Home page
  else
    @user = User.find_by_id(session[:user_id])
    erb :your_page
  end
end

get '/:short_url' do
  @url = Url.find_by_shorturl(params[:short_url])
  @url.counter = @url.counter + 1
  @url.save
  redirect "#{@url.longurl}"
end