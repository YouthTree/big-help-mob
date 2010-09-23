require 'spec/spec_helper'

describe PasswordReset do
  
  describe 'finding from a token' do
    
    it 'should return nil for a blank token' do
      PasswordReset.find(nil).should be_blank
      PasswordReset.find("").should be_blank
      PasswordReset.find("   ").should be_blank
    end
    
    it 'should return nil for an unknown token' do
      PasswordReset.find("some-random-token").should be_blank
      PasswordReset.find("some-other-random-token").should be_blank
      PasswordReset.find("1").should be_blank
      PasswordReset.find("12-another-token--2").should be_blank
    end
    
    it 'should return a user from their perishable token' do
      user = User.make!
      PasswordReset.find(user.perishable_token).should be_present
    end
    
    it 'should not return a user from their other fields' do
      user = User.make!
      PasswordReset.find(user.id).should be_blank
      PasswordReset.find(user.email).should be_blank
      PasswordReset.find(user.login).should be_blank
      PasswordReset.find(user.to_param).should be_blank
    end
    
    it 'should not be a new record' do
      user = User.make!
      password_reset = PasswordReset.find(user.perishable_token)
      password_reset.should be_present
      password_reset.should be_persisted
      password_reset.should_not be_new_record
    end
    
    it 'should have blank attributes on the found password reset' do
      user = User.make!
      password_reset = PasswordReset.find(user.perishable_token)
      password_reset.password.should be_blank
      password_reset.password_confirmation.should be_blank
      password_reset.email.should be_blank
    end
    
  end
  
  describe 'updating the password' do
    
    before :each do
      @user           = User.make!
      @password_reset = PasswordReset.find(@user.perishable_token)
    end
    
    it 'should return the users perishable token for id' do
      @password_reset.id.should == @user.perishable_token
    end
    
    it 'should return false if the password is blank' do
      @password_reset.update(:password => "", :password_confirmation => "something").should == false
    end
    
    it 'should return false if it\'s a new record' do
      mock(@password_reset).new_record? { true }
      @password_reset.update(:password => "newpass123", :password_confirmation => "newpass123").should == false
    end
    
    it 'should return true if it succeeds' do
      @password_reset.update(:password => "newpass123", :password_confirmation => "newpass123").should == true
    end
    
    it 'should reset the users perishable token on success' do
      mock(@password_reset.user).reset_perishable_token!
      @password_reset.update(:password => "newpass123", :password_confirmation => "newpass123").should == true
    end
    
    it 'should not update the token on two different password' do
      @password_reset.update(:password => "newpass123", :password_confirmation => "anotherpass123").should == false
    end
    
  end
  
  describe 'sending the initial reset' do
    
    it 'should be invalid without an email set' do
      password_reset = PasswordReset.new(:email => '')
      password_reset.should_not be_valid
      password_reset.errors[:email].should be_present
      password_reset.email.should == ''
    end
    
    it 'should be invalid with an incorrect user' do
      User.where(:email => 'nonexistant@email.com').delete_all
      password_reset = PasswordReset.new(:email => 'nonexistant@email.com')
      password_reset.should_not be_valid
      password_reset.errors[:user].should be_present
      password_reset.user.should be_blank
    end
    
    it 'should have the email set' do
      password_reset = PasswordReset.new(:email => 'nonexistant@email.com')
      password_reset.email.should == 'nonexistant@email.com'
    end
    
    describe 'when valid' do
      
      before :each do
        @user = User.make!
        @password_reset = PasswordReset.new(:email => @user.email)
      end
      
      
      it 'should be valid' do
        @password_reset.should be_valid
      end

      it 'should set the user' do
        @password_reset.user.should == @user
      end
      
      it 'should set the email' do
        @password_reset.email.should == @user.email
      end
      
      it 'should reset the persishable_token on save' do
        mock(@password_reset).user.times(any_times) { @user }
        mock(@user).reset_perishable_token!
        @password_reset.save
      end

      it 'should notify the user on save' do
        mock(@password_reset).user.times(any_times) { @user }
        mock(@user).notify! :password_reset
        @password_reset.save
      end
      
    end
    
    describe 'when invalid' do
      
    end
    
  end
  
end