require 'spec/spec_helper'

describe Subscriber do

  describe 'when validating a subscriber' do

    before :each do
      @subscriber = Subscriber.make
    end

    it 'should be invalid with a blank name' do
      @subscriber.name = ''
      @subscriber.should_not be_valid
      @subscriber.errors[:name].should be_present
      @subscriber.name = 'Test Name'
      @subscriber.should be_valid
      @subscriber.errors[:name].should be_blank
    end

    it 'should be invalid with a blank email' do
      @subscriber.email = ''
      @subscriber.should_not be_valid
      @subscriber.errors[:email].should be_present
      @subscriber.email = 'test@example.com'
      @subscriber.should be_valid
      @subscriber.errors[:email].should be_blank
    end

    it 'should be invalid with bad email addresses' do
      @subscriber.email = 'blah'
      @subscriber.should_not be_valid
      @subscriber.errors[:email].should be_present
      @subscriber.email = '2.2.2.2'
      @subscriber.should_not be_valid
      @subscriber.errors[:email].should be_present
      @subscriber.email = 'google.com'
      @subscriber.should_not be_valid
      @subscriber.errors[:email].should be_present
      @subscriber.email = '<sutto@sutto.net> "Test"'
      @subscriber.should_not be_valid
      @subscriber.errors[:email].should be_present
    end

  end

  describe 'subscribing to a mailing list' do

    subject { Subscriber.make }

    it 'should automatically subscribe on save' do
      subject.should_not be_persisted
      mock(CampaignMonitorWrapper).update_for_subscriber!(subject)
      subject.save
      subject.should be_persisted
    end

    it 'should not subscribe when the subscriber is invalid' do
      subject.should_not be_persisted
      subject.name = ''
      dont_allow(CampaignMonitorWrapper).update_for_subscriber!(subject)
      subject.save
      subject.should_not be_persisted
    end

  end

end
