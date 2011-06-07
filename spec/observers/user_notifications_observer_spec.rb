require 'spec_helper'

describe UserNotificationsObserver do

  it 'should call notify after creating a user' do
    user = User.make
    mock(user).notify!(:signup)
    user.save!
  end

  it 'should not call notify after updating a user' do
    user = User.make!
    dont_allow(user).notify!(:signup)
    user.update_attributes :email => 'test-2@example.com'
  end

end