module UsersHelper
  
  def rpx_identifiers_to_s(user)
    identifiers = user.rpx_identifiers.count :all, :group => :provider_name
    if identifiers.empty?
      "You have no stored external accounts."
    else
      name = identifiers.sort_by { |k, v| -v }.map { |k,v| pluralize(v, "#{k} account") }.to_sentence
      "You have external credentials stored for #{name}."
    end
  end  
  
  def rpxnow_link(text, url, opts = {})
    has_rpxnow
    options = options_with_class_merged(opts, :class => 'rpxnow')
    rpx_opts = options.delete(:rpx) || {}
    auth_token_params = [Rack::Utils.escape(request_forgery_protection_token.to_s), Rack::Utils.escape(form_authenticity_token.to_s)] * "="
    token_url = "#{url}#{url.include?("?") ? "&" : "?"}#{auth_token_params}"
    rpx_opts[:realm]     ||= Settings.rpx.realm
    rpx_opts[:token_url]   = token_url
    rpx_opts.each_pair do |k, v|
      options["data-rpxnow-#{k.to_s.gsub("_", "-")}"] = v
    end
    full_url = "http://#{rpx_opts[:realm]}.rpxnow.com/openid/v2/signin?token_url=#{Rack::Utils.escape(token_url)}"
    link_to text, full_url, options
  end
  
  def has_rpxnow
    return if defined?(@has_rpxnow) && @has_rpxnow
    rpxnow_js = "#{request.ssl? ? 'https://' : 'http://static.'}rpxnow.com/js/lib/rpx.js"
    has_js rpxnow_js, 'bhm/rpx_now'
    @has_rpxnow = true
  end
  
  def auth_selector_link(text, link)
    link_to(text, link, :id => 'auth-selector-link')
  end
  
end
