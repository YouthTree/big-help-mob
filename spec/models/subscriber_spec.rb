require 'spec/spec_helper'

describe Subscriber do
  
  describe 'when validating a subscriber' do
    
    before :each do
      @subscriber = Subscriber.new
    end
    
    it 'should be invalid with a blank email' do
      @subscriber.email = ''
      @subscriber.should_not be_valid
      @subscriber.errors[:email].should be_present
    end
    
    it 'should be invalid with a blank set of list ids' do
      @subscriber.list_ids = nil
      @subscriber.should_not be_valid
      @subscriber.errors[:list_ids].should be_present
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
    
    it 'should be invalid with non-present list ids' do
      mock(CampaignMonitorWrapper).available_list_ids { ["a", "b", "c"] }
      @subscriber.list_ids = ["d"]
      @subscriber.should_not be_valid
      @subscriber.errors[:list_ids].should be_present
    end
    
  end
  
  describe 'initialization' do
    
    before :each do
      @subscriber = Subscriber.new
    end
    
    it 'should default to a not being persisted' do
      @subscriber.should_not be_persisted
    end
    
    it 'should clear out invalid list ids' do
      mock(CampaignMonitorWrapper).available_list_ids { ["a", "b", "c"] }
      @subscriber.list_ids = ["d"]
      @subscriber.list_ids.should be_blank
    end
    
    it 'should include valid list ids' do
      mock(CampaignMonitorWrapper).available_list_ids { ["a", "b", "c"] }
      @subscriber.list_ids = ["b", "c"]
      @subscriber.list_ids.should == ["b", "c"]
    end
    
    it 'should let you initialize values from the a hash' do
      mock(CampaignMonitorWrapper).available_list_ids { ["a", "b", "c"] }
      @subscriber = Subscriber.new(:email => 'test@example.com', :list_ids => %w(a d), :name => 'Test User')
      @subscriber.email.should == 'test@example.com'
      @subscriber.list_ids.should == %w(a)
      @subscriber.name.should == 'Test User'
    end
    
  end
  
  describe 'when invalid' do
    
    before :each do
      @subscriber = Subscriber.new
      stub(@subscriber).valid?     { false }
      stub(@subscriber).persisted? { false }
      stub(@subscriber).persist!
      stub(@subscriber).subscribe!
    end
    
    it 'should call subscribe!' do
      dont_allow(@subscriber).subscribe!
      @subscriber.save
    end
    
    it 'should call persist!' do
      dont_allow(@subscriber).persist!
      @subscriber.save
    end
    
  end
  
  describe 'when already persisted' do
    
    before :each do
      @subscriber = Subscriber.new
      stub(@subscriber).valid?     { true }
      stub(@subscriber).persisted? { true }
      stub(@subscriber).persist!
      stub(@subscriber).subscribe!
    end
    
    it 'should call subscribe!' do
      dont_allow(@subscriber).subscribe!
      @subscriber.save
    end
    
    it 'should call persist!' do
      dont_allow(@subscriber).persist!
      @subscriber.save
    end
    
  end
  
  describe 'when valid and not already persisted' do
    
    before :each do
      @subscriber = Subscriber.new
      stub(@subscriber).valid?     { true }
      stub(@subscriber).persisted? { false }
      stub(@subscriber).persist!
      stub(@subscriber).subscribe!
    end
    
    it 'should call subscribe!' do
      mock(@subscriber).subscribe!
      @subscriber.save
    end
    
    it 'should call persist!' do
      mock(@subscriber).persist!
      @subscriber.save
    end
    
  end
  
end