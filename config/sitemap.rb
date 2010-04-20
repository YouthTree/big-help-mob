SitemapGenerator::Sitemap.default_host = "http://bighelpmob.org/"

SitemapGenerator::Sitemap.add_links do |sitemap|
  
  sitemap.add mission_path(:next), :priority => 1, :changefreq => Mission.next.first.try(:created_at)
  
  %w(about privacy_policy terms_and_conditions).each do |page|
    sitemap.add url_for(page.to_sym), :priority => 0.75, :changefreq => 'weekly'
  end
  
  sitemap.add contact_us_path, :priority => 0.75, :changefreq => 'weekly'
  
  Mission.viewable.find_each do |mission|
    sitemap.add mission_path(mission),      :priority => 0.75, :changefreq => 'weekly', :lastmod => mission.updated_at
    sitemap.add join_mission_path(mission), :priority => 0.75, :changefreq => 'weekly', :lastmod => mission.updated_at
  end
  
  sitemap.add sign_in_path,            :priority => 0.5, :changefreq => 'monthly'
  sitemap.add new_password_reset_path, :priority => 0.3, :changefreq => 'monthly'
  
end