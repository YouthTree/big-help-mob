module RpxNowHelper
  
  # Returns a short description of the rpx identifiers associated with a given user account,
  # namely for the user profile page so users can see how they logged in to the site.
  def rpx_identifiers_to_s(user)
    identifiers = user.rpx_identifiers.count :all, :group => :provider_name
    if identifiers.empty?
      tu 'authentication.no_external'
    else
      name = identifiers.sort_by { |k, v| -v }.map { |k,v| pluralize(v, "#{k} account") }.to_sentence
      ActiveSupport::SafeBuffer.new.tap do |buffer|
        buffer << "You have "
        buffer << content_tag(:abbr, "external credentials", :title => tu('authentication.external_explanation'))
        buffer << " stored for #{name}."
      end
    end
  end  
  
  # Returns an unobtrusive link (with html5 data attributes) that lets you bring up an RPXNow Dialog.
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
  
  # Automatically embeds the RPXNow Javascript once.
  def has_rpxnow
    return if defined?(@has_rpxnow) && @has_rpxnow
    rpxnow_js = "#{request.ssl? ? 'https://' : 'http://static.'}rpxnow.com/js/lib/rpx.js"
    has_js rpxnow_js
    @has_rpxnow = true
  end
  
end