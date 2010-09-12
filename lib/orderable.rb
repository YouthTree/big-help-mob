module Orderable
  extend ActiveSupport::Concern

  included do
    class_inheritable_accessor :orderable_field
  end

  def self.adapter
    User.configurations[Rails.env]["adapter"]
  end

  module ClassMethods
    
    def ordered
      order("#{quoted_orderable_field} ASC")
    end
    
    def orderable_field_is(field = nil)
      self.orderable_field = field.to_sym
    end
    
    def update_order(id_array = nil)
      id_array = Array(id_array).flatten.reject(&:blank?).map(&:to_i).uniq
      update_all orderable_sql_for_ids(id_array), ['id IN (?)', id_array]
    end

    def quoted_orderable_field
      "#{quoted_table_name}.#{connection.quote_column_name(orderable_field)}"
    end

    def orderable_sql_for_ids(ids)
      ids = ids.join(",")
      if Orderable.adapter =~ /^mysql/
        ["#{quoted_orderable_field} = FIND_IN_SET(id, ?)", ids]
      elsif Orderable.adapter =~ /^postgres/
        ["#{quoted_orderable_field} = STRPOS(?, ','||id||',')", ",#{ids},"]
      end
    end

  end

end