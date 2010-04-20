module RejectIfHelper
  
  def reject_if_proc(blacklist_values = %w(0), blank = true)
    proc do |attributes|
      attributes.all? do |k, v|
        (k.to_s[0] == ?_) || (blank && v.blank?) || blacklist_values.include?(v.to_s)
      end
    end
  end
  
end