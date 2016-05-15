class AnswersController < ApplicationController
  def index

  end

  def new

  end

  def create
    FBC.client.push(:answers, { body: params[:body] } )
    redirect_to answers_url, flash: 'Created answer'
  end

end
