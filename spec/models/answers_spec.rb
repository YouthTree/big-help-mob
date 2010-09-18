require 'spec/spec_helper'

describe Answers do
  dataset :answers_dataset

  before :each do
    @participation = Object.new
    @mission = missions.first
    @questions = questions
    mock(@participation).mission { @mission }
    stub(@mission).questions { questions }

    @answers = Answers.new(@participation)
  end

  it 'should allow assignment of attributes' do
    @answers.attributes = {:fred => 1, :wilma => 2}
  end
  
  it 'should yield to a block for each question' do
    @answers.each_question do |question, param|
      question.should be_a(Question)
    end
  end

end
