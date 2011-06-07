require 'spec_helper'

describe User do

  describe 'when generating slugs' do

    before :each do
      @user = User.make! :first_name => 'bob'
    end

    it 'should not change slugs if the updated model is the same' do
      old_slug = @user.to_param
      @user.update_attributes :first_name => 'BOB'
      @user.to_param.should == old_slug
    end

  end

  describe 'when finding users' do

    describe 'find_by_email_or_login' do

      before :each do
        @user = User.make!
      end

      it 'should return a user from then login' do
        User.find_by_email_or_login(@user.login).should == @user
      end

      it 'should return a user from their email' do
        User.find_by_email_or_login(@user.email).should == @user
      end

    end

  end

  describe 'the virtual name attribute' do

    before :each do
      @user = User.make(
        :display_name => 'Test Display Name',
        :first_name   => 'Test',
        :last_name    => 'User',
        :login        => 'test_user'
      )
    end

    describe 'when getting the name' do

      it 'should return the display name if present' do
        @user.name.should == 'Test Display Name'
      end

      it 'should return the full name if present' do
        @user.display_name = ''
        @user.name.should == 'Test User'
      end

      it 'should return the login if present' do
        @user.display_name = ''
        @user.first_name   = ''
        @user.last_name    = ''
        @user.name.should == 'test_user'
      end

      it 'should return "Unknown User" by default' do
        @user.display_name = ''
        @user.first_name   = ''
        @user.last_name    = ''
        @user.login        = ''
        @user.name.should == 'Unknown User'
      end

    end

    describe 'when checking if the name was changed' do

      before :each do
        @user.save
      end

      it 'should return true if the display name is set and changed' do
        @user.display_name = 'Another Display Name'
        @user.should be_name_changed
      end

      it 'should return true if the full name was changed' do
        @user.update_attributes :display_name => ''
        @user.first_name = 'Another First'
        @user.should be_name_changed
      end

      it 'should return true if the login was changed' do
        @user.update_attributes :display_name => nil, :first_name => nil, :last_name => nil
        @user.login = 'another_login'
        @user.should be_name_changed
      end

    end

    describe 'when checking the previous value of name' do
    end

  end

  describe 'when getting a users age' do

    it 'should return the correct values' do
      User.make(:date_of_birth => 18.years.ago).age.should   == 18
      User.make(:date_of_birth => (21.years + 6.months).ago).age.should == 21
      User.make(:date_of_birth => 143.months.ago).age.should == 11
    end

    it 'should have a default date of birth' do
      User.make(:date_of_birth => nil).date_of_birth.should == Date.new(1990, 1, 1)
      date = 21.years.ago
      User.make(:date_of_birth => date).date_of_birth.should == date
    end

  end

  describe 'permissions' do

    describe 'on users' do

      before :each do
        @user     = User.make
        @user_two = User.make
      end

      it 'should be able to edit itself' do
        @user.can?(:edit, @user).should be_true
      end

      it 'should be able to destroy itself' do
        @user.can?(:destroy, @user).should be_true
      end

      it 'should not be able to edit others' do
        @user.can?(:edit, @user_two).should be_false
      end

      it 'should not be able to destroy others' do
        @user.can?(:destroy, @user_two).should be_false
      end

      it 'should not be able to do arbitrary things on itself' do
        @user.can?(:laugh, @user).should be_false
      end

      it 'should not be able to do arbitrary things on others' do
        @user.can?(:laugh, @user_two).should be_false
      end

    end

    describe 'as an admin' do

      before :each do
        @user     = User.make(:admin => true)
        @user_two = User.make
      end

      it 'should be able to edit itself' do
        @user.can?(:edit, @user).should be_true
      end

      it 'should be able to destroy itself' do
        @user.can?(:destroy, @user).should be_true
      end

      it 'should be able to edit others' do
        @user.can?(:edit, @user_two).should be_true
      end

      it 'should be able to destroy others' do
        @user.can?(:destroy, @user_two).should be_true
      end

      it 'should let you perform arbitrary actions on things' do
        @user.can?(:transmorgify, User).should be_true
        @user.can?(:reclaim, Object.new).should be_true
        @user.can?(:test, Object).should be_true
        @user.can?(:laugh, @user_two).should be_true
      end

    end

    describe 'in general' do

      before :each do
        @user = User.make
      end

      it 'should return false when the method is not defined' do
        target = stub!.respond_to?(:mockable_by?) { false }
        @user.can?(:mock, target).should be_false
      end

      it 'should return false when the method returns false' do
        target = mock!.respond_to?(:removeable_by?) { true }
        mock(target).removeable_by?(@user)          { false}
        @user.can?(:remove, target).should be_false
      end

      it 'should return true if defined and it returns true' do
        target = mock!.respond_to?(:collateable_by?) { true }
        mock(target).collateable_by?(@user)          { true }
        @user.can?(:collate, target).should be_true
      end

    end

  end

end
