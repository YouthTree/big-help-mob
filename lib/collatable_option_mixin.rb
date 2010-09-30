module CollatableOptionMixin
  extend ActiveSupport::Concern
  
  module ClassMethods
    
    def has_collatable_option(name, scope_key)
      belongs_to name, :class_name => "CollatableOption",
        :conditions => {:scope_key => scope_key}
      singleton_class.class_eval(<<-END, __FILE__, __LINE__)
      
        def #{name}_options_scope
          CollatableOption.where(:scope_key => #{scope_key.inspect})
        end
      
        def count_on_#{name}
          count :all, :group => :#{name}_id
        end
        
        def count_on_#{name}_by_name
          ActiveSupport::OrderedHash.new.tap do |h|
            id_to_name = #{name}_options_scope.id_to_names
            count_on_#{name}.each_pair do |k, v|
              h[id_to_name[k]] = v
            end
          end
        end
        
        def count_on_#{name}_by_value
          ActiveSupport::OrderedHash.new.tap do |h|
            id_to_name = #{name}_options_scope.id_to_values
            count_on_#{name}.each_pair do |k, v|
              h[id_to_name[k]] = v
            end
          end
        end
      
      END
    end
    
  end
end