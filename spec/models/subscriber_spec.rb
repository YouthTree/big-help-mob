require 'spec_helper'

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
      mock(MailingListWorker).queue_for!(subject)
      subject.save
      subject.should be_persisted
    end

    it 'should not call it twice' do
      subject.save
      dont_allow(MailingListWorker).queue_for!.with_any_args
      subject.name = 'A different name'
      subject.save
    end

    it 'should not do it after finding the saved record' do
      subject.save
      returned = Subscriber.find(subject.id)
      dont_allow(MailingListWorker).queue_for!.with_any_args
      returned.name = 'A different name'
      returned.save
    end

    it 'should not subscribe when the subscriber is invalid' do
      subject.should_not be_persisted
      subject.name = ''
      dont_allow(MailingListWorker).queue_for!.with_any_args
      subject.save
      subject.should_not be_persisted
    end

  end

end
