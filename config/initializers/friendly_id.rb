Slug.class_eval do
  attr_accessible :all
end

FriendlyId::ActiveRecordAdapter::FinderMethods.module_eval do
  
  def find_using_slug(*args, &blk)
  end
  
end