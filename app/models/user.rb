class User < ActiveRecord::Base
  has_many :tweets

  validates :user_name, :presence => true,
            :uniqueness=>true

  validates :password, :confirmation => true,
            :length => {:within => 6..20},
            :allow_blank => true,
            :on => :create


  def self.authenticate(user_name, password)
      user = User.find_by_user_name(user_name)
      if user != nil && user.password == password
        return true
      else
        return false
    end
  end

end
