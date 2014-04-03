class Follower < ActiveRecord::Base
  before_save :authenticate

  belongs_to :user

  def self.authenticate
      user = User.find_by_user_name(self.user_name)
      if user != nil
        return true
      else
        return false
    end
  end


end