class WordCountValidator < ActiveModel::EachValidator
  
  def validate_each(record, attribute, value)
    max_words  = options[:max_words] || 100
    min_words  = options[:min_words] || 0
    count = value.to_s.scan(/\w+/).size
    if count < min_words
      record.errors.add(attribute, :too_few_words, :min_count => min_words, :actual_count => count)
    elsif count > max_words
      record.errors.add(attribute, :too_many_words, :max_count => max_words, :actual_count => count)
    end 
  end
  
end