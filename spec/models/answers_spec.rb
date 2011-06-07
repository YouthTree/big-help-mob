require 'spec_helper'

describe Answers do
  dataset :answers_dataset

  context 'no questions' do
    before :each do
      @participation = Object.new
      @mission = missions.first
      mock(@participation).mission { @mission }
      stub(@mission).questions { [] }

      @answers = Answers.new(@participation)
    end

    it 'should indicate that it is not needed' do
      @answers.should_not be_needed
    end
  end

  context 'with some questions' do
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
      @answers.each_question do |question, params|
        question.should be_a(Question)
      end
    end

    it 'should yield a block to each answer' do
      @answers.each_answer do |answer, params|
        answer.should be_a(String)
      end
    end

    it 'should retrieve a Hash of answers' do
      stub(@participation).raw_answers.returns('')
      stub(@participation, 'raw_answers=')

      answers = @answers.answers
      answers.should be_a(Hash)
    end

    it 'should retrieve the raw answers if they are not a hash' do
      stub(@participation).raw_answers.returns({})
      stub(@participation, 'raw_answers=')

      answers = @answers.answers
      answers.should be_a(Hash)
    end
  end

end
