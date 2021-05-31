require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    # validation tests/examples here
    it 'saves properly with all 5 fields' do
      @user = User.new(firstname: "Bob", lastname: "Builder", email: "bob@builder.com", password: "build", password_confirmation: "build")
      expect {
        @user.save
      }.to change(User, :count).by(1)
    end
    it 'validates firstname' do
      @user = User.new(lastname: "Builder", email: "bob@builder.com", password: "build", password_confirmation: "build")
      @user.save
      expect(@user.errors.full_messages).to include("Firstname can't be blank")
    end
    it 'validates lastname' do
      @user = User.new(firstname: "Bob", email: "bob@builder.com", password: "build", password_confirmation: "build")
      @user.save
      expect(@user.errors.full_messages).to include("Lastname can't be blank")
    end
    it 'validates email' do
      @user = User.new(firstname: "Bob", lastname: "Builder", password: "build", password_confirmation: "build")
      @user.save
      expect(@user.errors.full_messages).to include("Email can't be blank")
    end
    it 'validates password' do
      @user = User.new(firstname: "Bob", lastname: "Builder", email: "bob@builder.com", password_confirmation: "build")
      @user.save
      expect(@user.errors.full_messages).to include("Password can't be blank")
    end
    it 'validates password_confirmation' do
      @user = User.new(firstname: "Bob", lastname: "Builder", email: "bob@builder.com", password: "build")
      @user.save
      expect(@user.errors.full_messages).to include("Password confirmation can't be blank")
    end
    it 'does not allow nonmatching passwords' do
      @user = User.new(firstname: "Bob", lastname: "Builder", email: "bob@builder.com", password: "build", password_confirmation: "foobar")
      @user.save
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end
    it 'does not allow duplicate emails (case insensitive)' do
      @user = User.new(firstname: "Bob", lastname: "Builder", email: "bob@builder.com", password: "build", password_confirmation: "build")
      expect {
        @user.save
      }.to change(User, :count).by(1)
      @user2 = User.new(firstname: "Joe", lastname: "Destroyer", email: "BOB@builder.com", password: "destroy", password_confirmation: "destroy")
      @user2.save
      expect(@user2.errors.full_messages).to include("Email has already been taken")
    end
    it 'Does not allow short passwords < 5 chars' do
      @user = User.new(firstname: "Bob", lastname: "Builder", email: "bob@builder.com", password: "bui", password_confirmation: "bui")
      @user.save
      expect(@user.errors.full_messages).to include("Password is too short (minimum is 5 characters)")
    end
  end

  describe ".authenticate_with_credentials" do
    it 'Does not authenticate with invalid into' do
      @user = User.new(firstname: "Bob", lastname: "Builder", email: "bob@builder.com", password: "build", password_confirmation: "build")
      @user.save
      @authenticate = User.authenticate_with_credentials("bob@builder.com", "builderino")
      expect(@authenticate).to be_falsey
    end
    it 'Does authenticate with valid into' do
      @user = User.new(firstname: "Bob", lastname: "Builder", email: "bob@builder.com", password: "build", password_confirmation: "build")
      @user.save
      @authenticate = User.authenticate_with_credentials("bob@builder.com", "build")
      expect(@authenticate).to be_truthy
    end
    it 'ignores trailing whitespace on emails' do
      @user = User.new(firstname: "Bob", lastname: "Builder", email: "bob@builder.com", password: "build", password_confirmation: "build")
      @user.save
      @authenticate = User.authenticate_with_credentials("   bob@builder.com", "build")
      expect(@authenticate).to be_truthy
    end
    it 'ignores case in user email input' do
      @user = User.new(firstname: "Bob", lastname: "Builder", email: "bob@builder.com", password: "build", password_confirmation: "build")
      @user.save
      @authenticate = User.authenticate_with_credentials("BOB@buiLder.com", "build")
      expect(@authenticate).to be_truthy
    end
  end
end