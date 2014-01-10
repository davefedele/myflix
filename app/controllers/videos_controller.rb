class VideosController < ApplicationController

  def index
    @videos = Video.all
    @categories = Category.all
  end

  def show
    @video = Video.find_by(slug: params[:id])
  end
end