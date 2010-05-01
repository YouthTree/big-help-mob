module Admin::EmailHelper
  
  def preview_of_email_part(email, part)
    example = email.example_rendered_email
    inner = example.send(part)
    if part == :html_content
      inner = inner.html_safe
    else
      inner = content_tag(:pre, inner)
    end
    part_name = part.to_s.humanize.downcase
    id = "email-preview-for-#{part.to_s.dasherize}"
    inner_preview = content_tag(:p, "Your rendered #{part_name} will look like:".html_safe, :class => 'email-preview-title')
    inner_preview << inner
    content_for(:rendered_previews, content_tag(:div, inner_preview, :id => id))
    preview_text = "#{link_to 'Click here', "##{id}", :class => 'preview-email-section'} to preview the rendered #{part_name}.".html_safe
    preview_hint = content_tag(:p, preview_text, :class => 'inline-hints')
    content_tag(:li, preview_hint, :class => 'preview-email-section', :id => "preview-of-#{part.to_s.dasherize}")
  end
  
end