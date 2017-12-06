require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factoryBot object' do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it 'has many calculations' do
    should have_many(:calculations)
  end

  before :each do
    @user = FactoryBot.build(:user)
  end

  context 'it validates the credentials' do
    it 'should not be valid without an email' do
      @user.email = nil
      expect(@user).to_not be_valid
    end

    it 'should not be valid without a username' do
      @user.username = nil
      expect(@user).to_not be_valid
    end

    it 'should not be valid without a password' do
      @user.password = nil
      expect(@user).to_not be_valid
    end
  end

  context 'When a new User is initialized' do
    it 'is a new user' do
      expect(@user).to be_a_new(User)
    end

    it 'should be a valid User object' do
      expect(@user).to be_valid
    end
  end
end
