module Orderable
  extend ActiveSupport::Concern

  included do
    class_inheritable_accessor :orderable_field
  end

  def self.adapter
    User.configurations[Rails.env]["adapter"]
  end

  module ClassMethods
    
    def orderable_field_is(field = nil)
      self.orderable_field = field.to_sym
    end
    
    def update_order(id_array = nil)
      id_array = Array(id_array).flatten.reject(&:blank?).map(&:to_i).uniq
      update_all orderable_sql_for_ids(orderable_field, id_array), ['id IN (?)', id_array]
    end

    def orderable_sql_for_ids(field, ids)
      ids = ids.join(",")
      field = "#{quoted_table_name}.#{connection.quote_column_name(field)}"
      if Orderable.adapter =~ /^mysql/
        ["#{field} = FIND_IN_SET(id, ?)", ids]
      elsif Orderable.adapter =~ /^postgres/
        ["#{field} = STRPOS(?, ','||id||',')", ",#{ids},"]
      end
    end

  end

end