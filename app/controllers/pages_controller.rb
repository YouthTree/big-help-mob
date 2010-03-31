class PagesController < ApplicationController

  def self.def_page(name, key = "pages.#{name.to_s.dasherize}")
    define_method(name) { render_page! key }
  end

  # Site index
  def index
    hide_title!
  end
  
  def_page :about
  def_page :privacy_policy
  def_page :terms_and_conditions

  protected
  
  def render_page!(key)
    @content = Content.find_by_key!(key.to_s)
    self.page_title = @content.title
    render :action => 'show'
  end

end
