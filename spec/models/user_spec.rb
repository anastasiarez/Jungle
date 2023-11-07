require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'is valid with matching password and password_confirmation' do
      user = User.new(
        email: 'test@example.com',
        first_name: 'John',
        last_name: 'Doe',
        password: 'password',
        password_confirmation: 'password'
      )
      expect(user).to be_valid
    end

    it 'is not valid with mismatched password and password_confirmation' do
      user = User.new(
        email: 'test@example.com',
        first_name: 'John',
        last_name: 'Doe',
        password: 'password',
        password_confirmation: 'different_password'
      )
      expect(user).not_to be_valid
      expect(user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    it 'is not valid without a password' do
      user = User.new(
        email: 'test@example.com',
        first_name: 'John',
        last_name: 'Doe'
      )
      expect(user).not_to be_valid
      expect(user.errors.full_messages).to include("Password can't be blank")
    end

    it 'is not valid without an email' do
      user = User.new(
        first_name: 'John',
        last_name: 'Doe',
        password: 'password',
        password_confirmation: 'password'
      )
      expect(user).not_to be_valid
      expect(user.errors.full_messages).to include("Email can't be blank")
    end

    it 'is not valid with a duplicate (case-insensitive) email' do
      user = User.create(
        email: 'test@example.com',
        first_name: 'John',
        last_name: 'Doe',
        password: 'password',
        password_confirmation: 'password'
      )
      duplicate_user = User.new(
        email: 'TEST@example.com',
        first_name: 'Jane',
        last_name: 'Smith',
        password: 'otherpassword',
        password_confirmation: 'otherpassword'
      )
      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors.full_messages).to include("Email has already been taken")
    end

    it 'is valid with a password that meets the minimum length' do
      user = User.new(
        email: 'test@example.com',
        password: 'password123', # Password with at least 8 characters
        password_confirmation: 'password123'
      )
      expect(user).to be_valid
    end
  
    it 'is not valid with a password that is too short' do
      user = User.new(
        email: 'test@example.com',
        password: 'short', # Password with less than 8 characters
        password_confirmation: 'short'
      )
      expect(user).not_to be_valid
      expect(user.errors.full_messages).to include("Password is too short (minimum is 8 characters)")
    end

    it 'authenticates with email containing spaces' do
      user = User.create(
        email: 'example@domain.com',
        password: 'password'
      )
      authenticated_user = User.authenticate_with_credentials(' example@domain.com ', 'password')
      expect(authenticated_user).to eq(user)
    end
    
    it 'authenticates with case-insensitive email' do
      user = User.create(
        email: 'example@domain.com',
        password: 'password'
      )
      authenticated_user = User.authenticate_with_credentials('EXAMPLe@DOMAIN.CoM', 'password')
      expect(authenticated_user).to eq(user)
    end    
  end  
  
  describe '.authenticate_with_credentials' do
      it 'authenticates with valid credentials' do
        user = User.create(email: 'test@example.com', password: 'password123', password_confirmation: 'password123')
        authenticated_user = User.authenticate_with_credentials('test@example.com', 'password123')
        expect(authenticated_user).to eq(user)
      end
  
      it 'does not authenticate with incorrect password' do
        user = User.create(email: 'test@example.com', password: 'password123', password_confirmation: 'password123')
        authenticated_user = User.authenticate_with_credentials('test@example.com', 'wrongpassword')
        expect(authenticated_user).to be_nil
      end
  
      it 'does not authenticate with incorrect email' do
        user = User.create(email: 'test@example.com', password: 'password123', password_confirmation: 'password123')
        authenticated_user = User.authenticate_with_credentials('wrongemail@example.com', 'password123')
        expect(authenticated_user).to be_nil
      end
  
      it 'authenticates with email case-insensitivity' do
        user = User.create(email: 'test@example.com', password: 'password123', password_confirmation: 'password123')
        authenticated_user = User.authenticate_with_credentials('Test@Example.COM', 'password123')
        expect(authenticated_user).to eq(user)
      end
  end
end
