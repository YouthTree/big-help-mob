class AnswersDataset < Dataset::Base

  def load
    create_record \
      :question,
      :answer => '42',
      :question => 'What is 6 times 7?'
    create_record \
      :question,
      :answer => '1.23 miles per hour',
      :question => 'What... is the air-speed velocity of an unladen swallow?'
    create_record \
      :question,
      :answer => 'African',
      :question => 'What do you mean? An African or European swallow?'

    create_record \
      :mission,
      :name => 'Find the Holy Grail',
      :description => 'Arthur sets off through England to find the Holy Grail',
      :occurs_at => Date.new(1998, 8, 4)
  end

end
