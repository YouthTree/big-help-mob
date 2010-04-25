module Admin::ContentHelper
  
  def comment_as_html record
    simple_format h(record.comment.to_s)
  end
  
end