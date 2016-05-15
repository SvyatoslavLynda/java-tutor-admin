class AnswersController < ApplicationController
  def show
    @answer = Answer.find(params[:id])
  end

  def edit
    @answer = Answer.find(params[:id])
  end

  def create
    answer = Answer.new(params)
    answer.save
    redirect_to "/questions/#{answer.question_id}"
  end

  def update
    answer = Answer.new(params)
    answer.save
    redirect_to "/questions/#{answer.question_id}"
  end

  def destroy
    answer = Answer.find(params[:id])
    answer.destroy
    redirect_to "/questions/#{answer.question_id}"
  end
end
