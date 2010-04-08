module UsersHelper
  
  def input_type_for_origin(v)
    v = v.to_s.downcase
    (v.blank? || User::ORIGIN_CHOICES.any? { |va| va.downcase == v }) ? :select : :string
  end
  
end
