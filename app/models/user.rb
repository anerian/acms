class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.logged_in_timeout = 2.days
  end
  
  has_many :pages
end
