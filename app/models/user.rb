class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: { case_insensitive: true }
  validates :password, length: { minimum: 8 } # Adjust the minimum length as needed

  def self.authenticate_with_credentials(email, password)
    
    email = email.strip.downcase  # Remove leading/trailing spaces and convert to lowercase
    user = find_by("lower(email) = ?", email)
    user&.authenticate(password) || nil
  end
end
