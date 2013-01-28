# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  # (these must all be accessible columns in the database)

  # latest version of Rails includes this method:
  # as long as there is a password_digest column in the database, 
  # has_secure_password requires presence of password, requires they match, and
  # adds an authenticate method to compare an encrypted passwrod to 
  # the password_digest
  	# Validations for presence of password, confirmation of password (using
    # a "password_confirmation" attribute) are automatically added.
    # You can add more validations by hand if need be.
  has_secure_password
  # has_many association for microposts
  # dependent: :destroy arranges for dependent microposts to be destroyed when
  # user itself is destroyed
  has_many :microposts, dependent: :destroy      

  # use before_save callback to force Rails to downcase email attribute 
  # before saving user to the database in order to assure email uniqueness
  # since not all database adapters use case-sensitive indices
  # this line passes a block to the before_save callback and sets user's email
  # address to a lowercase version of its current value
  # following line could be: before_save { |user| user.email = email.downcase }
  before_save { self.email.downcase! }

  # now let's add a callback to create the remember token
  # a callback is a method that gets invoked at a particular point in the 
  # lifetime of an Active Record object (see Rails API entry on callbacks)
  before_save :create_remember_token

  validates :name, presence: true, length: {maximum: 50}
  # same as validates(:name, presence: true)
  # validate email with regex
  # VALID_EMAIL_REGEX is a constant
  # \A 				match start of string
  # [\w+\-.]+		at least one word char, plus, hyphen, or dot
  # @ 				literal "at sign"
  # [a-z\d\-.]+ 	at least one letter, digit, hyphen, or dot
  # \.				literal dot
  # [a-z]+			at least one letter
  # \z 				match end of string
  # /				end of regex
  # i 				case insensitive
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: 	true, 
  					format: 	{ with: VALID_EMAIL_REGEX }, 
  					uniqueness: { case_sensitive: false }

  # presence and length validations for password
  validates :password, length: {minimum: 6}  # presence: true, no longer needed
  validates :password_confirmation, presence: true

  # the create_remember_token is only used internally so we make it private in 
  # order to prevent it from being exposed to outside users (although now 
  # User.first.create_remember_token on the console will raise a NoMethodError
  # exception)
  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
