helpers do
  def authenticate(user_name)
      user = User.find_by_user_name(user_name)
      if user != nil
        return true
      else
        return false
    end
  end
end