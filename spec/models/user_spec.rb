require 'spec/spec_helper'

describe User do
  
  context 'when generating slugs' do
    
    before :each do
      @user = User.make! :first_name => "bob"
    end
    
    it 'should not change slugs if the updated model is the same' do
      old_slug = @user.to_param
      @user.update_attributes :first_name => "BOB"
      @user.to_param.should == old_slug
    end
    
  end
  
end