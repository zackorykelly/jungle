class User < ActiveRecord::Base

  has_secure_password

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :password, presence: true, length: { minimum: 5 }
  validates :password_confirmation, presence: true


  def self.authenticate_with_credentials(email, password)
    email = email.strip
    email = email.downcase
    @current_user = User.find_by email: email
    @current_user.authenticate(password)
  end

end
