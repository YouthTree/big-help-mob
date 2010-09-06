module PagesHelper
  
  def each_listing_page(&blk)
    keys = %w(about privacy_policy terms_and_conditions).map { |k| "pages.#{k.dasherize}" }
    Content.where(:key => keys).select('title, `key`').all.each do |page|
      yield page.title, page.key.gsub(/^pages\./, '').underscore.to_sym
    end
  end
  
end

