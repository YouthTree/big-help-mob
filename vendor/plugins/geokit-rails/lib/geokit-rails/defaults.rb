module Geokit
  # These defaults are used in Geokit::Mappable.distance_to and in acts_as_mappable
  @@default_units = :miles
  @@default_formula = :sphere

  [:default_units, :default_formula].each do |sym|
    class_eval <<-EOS, __FILE__, __LINE__
      def self.#{sym}
        if defined?(#{sym.to_s.upcase})
          #{sym.to_s.upcase}
        else
          @@#{sym}
        end
      end

      def self.#{sym}=(obj)
        @@#{sym} = obj
      end
    EOS
  end
  Geokit::Geocoders.logger = ActiveRecord::Base.logger
end
