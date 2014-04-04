helpers do
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
    p minutes
    if minutes < 1440
      time_stamp.strftime("Posted at %I:%M%p")
    else
      time_stamp.strftime("Posted on %m/%d/%Y at %I:%M%p")
    end

    # if minutes < 0
    #   return nil
    # elsif minutes < 5
    #   "posted less 5 minutes ago"
    # elsif minutes < 10
    #   "posted less than 10 minutes ago"
    # elsif minutes < 30
    #   "posted less than 30 minutes ago"
    # elsif minutes < 60
    #   "posted less than an hour ago"
  end
end