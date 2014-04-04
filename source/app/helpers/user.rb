helpers do
  # This will return the current user, if they exist
  # Replace with code that works with your application
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by_id(session[:user_id])
    end
  end

  def authenticate(user_name)
      p user_name
      user = User.find_by_user_name(user_name)
      if user != nil
        return true
      else
        return false
    end
  end

  # Returns true if current_user exists, false otherwise
  def logged_in?
    !current_user.nil?
  end

  # def current_user(property, query)
  #   User.where("#{property} = ?", query).first
  # end

  # def valid_user?(params_password, actual_password) # BUGBUG
  #   user = User.find_by_user_name(user_name)
  #       if user != nil
  #   params_password == actual_password
  # end
end