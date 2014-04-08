helpers do
#CR - refactor : adding the current user helper method
  def current_user
     @user ||= User.find(session[:user_id]) if session[:user_id]
  end

#CR move this to user model
  def authenticate(user_name)
      user = User.find_by_user_name(user_name)
      if user != nil
        return true
      else
        return false
    end
  end


  def time_since_tweet(time_stamp)
     minutes = ((Time.now - time_stamp)/60).round
     if minutes < 1440
       time_stamp.strftime("Posted at %I:%M%p")
     else
      time_stamp.strftime("Posted on %m/%d/%Y at %I:%M%p")
     end
   end
end
