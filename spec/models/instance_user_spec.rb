describe InstanceManager::InstanceUser do

  let(:model) { InstanceManager::InstanceUser }

  before do
    @instance_user = model.new user: user = create_private_user, instance: create_instance_model, creator: user
  end

  subject { @instance_user }

  it { should be_valid }

  describe 'when user/instance combination is not unique' do
    before { model.create user: @instance_user.user, instance: @instance_user.instance, creator: @instance_user.user }
    it { should_not be_valid }
  end

  describe 'when multiple InstanceUsers are associated with the same instance' do
    before { model.create user: create_private_user, instance: @instance_user.instance, creator: @instance_user.user }
    it { should be_valid }
  end

  describe 'when multiple InstanceUsers are associated with the same user' do
    before { model.create user: @instance_user.user, instance: create_instance_model, creator: @instance_user.user }
    it { should be_valid }
  end

end
