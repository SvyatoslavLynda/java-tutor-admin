class QuestionsController < ApplicationController
  def show
    @question = Question.find(params[:id])
  end

  def edit
    @question = Question.find(params[:id])
  end

  def create
    question = Question.new(params)
    question.save
    redirect_to "/articles/#{question.article_id}"
  end

  def update
    question = Question.new(params)
    question.save
    redirect_to "/articles/#{question.article_id}"
  end

  def destroy
    question = Question.find(params[:id])
    question.destroy
    redirect_to "/articles/#{question.article_id}"
  end
end
