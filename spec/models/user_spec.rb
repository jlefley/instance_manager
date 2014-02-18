require 'spec_helper'

describe InstanceManager::User do

  before do
    Thread.current[:request_host] = 'example.com'
    @user = InstanceManager::User.new email: 'test@example.com'
  end
  
  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_me) }

  it { should be_valid }

  describe 'when email is not present' do
    before { @user.email = ' ' }
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

  describe 'when password is required' do

    before do
      @user.stub(password_required?: true)
    end

    describe 'when password is not present' do
      before { @user.password = @user.password_confirmation = ' ' }
      it { should_not be_valid }
    end
    
    describe 'when password does not match confirmation' do
      before do
        @user.password_confirmation = 'mismatch'
        @user.password = '123456aA'
      end
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

    describe 'when password and password confirmation are valid' do
      before { @user.password = @user.password_confirmation = '123456aA' }
      it { should be_valid }
    end

  end

  describe 'when email address is already taken' do
    before do
      create_private_user email: @user.email.upcase
    end
    it { should_not be_valid }
  end
  
  describe 'when model has an encrypted password and persisted and password and password confirmation are blank' do
    before do
      @user.encrypted_password = 'abc'
      @user.save
    end
    it 'should be valid' do
      @user.class.find(id: @user.id).should be_valid
    end
  end

  describe 'when instantiated with protected attribute' do
    it 'should not set the protected attribute' do
      user = build_private_user sign_in_count: 5
      user.sign_in_count.should be_nil
    end
  end

  describe 'when updating protected attributes' do
    it 'should not set the protected attribute' do
      @user.save
      @user.update_attributes sign_in_count: 5
      @user.class.first(id: @user.id).sign_in_count.should == 0
    end
  end

  describe 'when created' do
    it 'should generate a random username' do
      @user.save
      @user.username.length.should == 8
    end
    describe 'when generated username is not unique' do
      it 'should generate a new username until a unique sequence is found' do
        @user.save
        user = build_private_user
        user.stub(:generate_username).and_return(@user.username, '123')
        user.save.username.should == '123'
      end
    end
  end

end
