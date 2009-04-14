class User < ActiveRecord::Base
  validates_presence_of     :name, :email, :salt, :hashed_password
  validates_uniqueness_of   :email
 
  validates_format_of       :email, 
                            :with => /^\s*[a-z0-9\!\#\$\%\&\'\*\+\/=\?\^_\`\{\|}~-]+(\.[a-z0-9\!\#\$\%\&\'\*\+\/=\?\^_\`\{\|}~-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.([a-z]{2,})\s*$/i,
                            :message => "The email address is invalid."
 
  attr_accessor             :password_confirmation
  validates_confirmation_of :password, :if => lambda {|user| !user.password.blank?}
  validates_presence_of     :password, :on => :create
  validates_presence_of     :password_confirmation, :if => lambda {|user| !user.password.blank?} 

  def validate
    errors.add( "password", "Missing password") if hashed_password.blank?
  end

  def self.authenticate(email, password)
    user = User.find_by_email(email)
    if user
      expected_password = encrypted_password(password, user.salt)
      user = nil if user.hashed_password != expected_password
    end
    user
  end

  # 'password' is a virtual attribute
  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end

  def after_destroy
    if User.count.zero?
      raise "Can't delete last user"
    end
  end

  def remember_me
    self.remember_token_expires = 2.weeks.from_now
    self.remember_token = OpenSSL::Digest::SHA1.hexdigest("#{self.salt}--#{self.email}--#{self.remember_token_expires}")
    self.save
  end

  def forget_me
    self.remember_token_expires = nil
    self.remember_token = nil
    self.save
  end

private
 
  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

  def self.encrypted_password(password, salt)
    string_to_hash = password + "BF132602-5A3F-4C8B-824C-8CD9FE89D94A" + salt
    OpenSSL::Digest::SHA1.hexdigest(string_to_hash)
  end

end
