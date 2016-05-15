class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new

  end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    Article.new(params).save
    redirect_to '/'
  end

  def update
    Article.new(params).save
    redirect_to '/'
  end

  def destroy
    Article.find(params[:id]).destroy
    redirect_to '/'
  end
end
