module ContentHelper
  
  def has_ckeditor
    has_jammit_js :ckeditor
  end
  
  def content_section(key, options = {})
    content = Content[normalized_content_scope(key, options.delete(:scope))]
    div_options = options_with_class_merged(options, :class => "embedded-content #{key.gsub(".", "-")}")
    content_tag(:div, content.try(:content_as_html).to_s, div_options)
  end

  alias cs content_section
  
  def faq(questions, title = "Frequently Asked Questions")
    return if questions.blank?
    inner = ActiveSupport::SafeBuffer.new
    faqs  = ActiveSupport::SafeBuffer.new
    questions.each_with_index do |question, idx|
      faqs << content_tag(:dt, question.question, :class => (idx == 0 ? "first" : nil))
      faqs << content_tag(:dd, question.answer_as_html)
    end
    inner << content_tag(:h3, title)
    inner << content_tag(:dl, faqs, :class => "frequently-asked-questions")
    inner
  end
  
  def social_media_link(name, text, link)
    link_to text.html_safe, link, :title => text, :class => "social-media-link #{name.to_s.dasherize}"
  end
  
end