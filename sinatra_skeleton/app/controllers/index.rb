enable :sessions

get '/' do
  # Look in app/views/index.erb
  erb :index
end

post '/' do
  # uses params to query db
  # for valid infor
  # set sessions
  redirect '/:userpage'
end

get '/:userpage' do
  # render appropriate view

  erb :userpage
end


