class PagesController < ApplicationController

  def show
    @questions = Question.visible.ordered.all
  end

end
