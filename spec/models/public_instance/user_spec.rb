require 'spec_helper'

describe InstanceManager::PublicInstance::User do

  before do
    @user = build_public_user
  end
  
  subject { @user }

  it { should respond_to(:username) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_me) }

  it { should be_valid }

  describe 'when username is not present' do
    before { @user.username = ' ' }
    it { should_not be_valid }
  end

  describe 'when email is not present' do
    before { @user.email = ' ' }
    it { should_not be_valid }
  end

  describe 'when username is too long' do
    before { @user.username = 'a' * 51 }
    it { should_not be_valid }
  end

  describe 'when email format is invalid' do
    it 'should be invalid' do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end      
    end
  end

  describe 'when email format is valid' do
    it 'should be valid' do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end      
    end
  end

  describe 'when password is not present' do
    before { @user.password = @user.password_confirmation = ' ' }
    it { should_not be_valid }
  end
  
  describe 'when password does not match confirmation' do
    before { @user.password_confirmation = 'mismatch' }
    it { should_not be_valid }
  end

  describe 'with a password that is too short' do
    before { @user.password = @user.password_confirmation = 'a' * 5 + 'A' + '1' }
    it { should_not be_valid }
  end

  describe 'with a password that is too long' do
    before { @user.password = @user.password_confirmation = 'a' * 99 + 'A' + '1' }
    it { should_not be_valid }
  end

  describe 'with a password that is not complex enough' do
    before { @user.password = @user.password_confirmation = 'a' * 10 }
    it { should_not be_valid }
  end

  describe 'when email address is already taken' do
    before do
      create_public_user username: 'newuser', email: @user.email.upcase
    end
    it { should_not be_valid }
  end
  
  describe 'when username is already taken' do
    before do
      create_public_user username: @user.username.upcase, email: 'newuser@example.com'
    end
    it { should_not be_valid }
  end

  describe 'when model has been persisted and password and password confirmation are blank' do
    before do
      @user.save
    end
    it 'should be valid' do
      @user.class.find(id: @user.id).should be_valid
    end
  end

  describe 'when username is included in reserved list' do
    it 'should not be valid' do
      @user.username = 'jason lefley'
      @user.should_not be_valid
      @user.username = 'drw'
      @user.should_not be_valid
    end
  end

  describe 'when updating attributes' do
    it 'should update user with the specified attributes' do
      user = create_public_user
      user.update_attributes username: 'some_new_username'
      user.class.first(username: 'some_new_username').should_not be_nil
    end
  end

end
