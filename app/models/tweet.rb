class Tweet < ActiveRecord::Base
  belongs_to :user

  validates :input, :confirmation => true,
            :length => {:within => 1..140},
            :allow_blank => true,
            :on => :create
end
