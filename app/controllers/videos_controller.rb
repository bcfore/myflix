class VideosController < ApplicationController
  before_action :require_user

  def index
    @categories = Category.joins(:videos).distinct.order(:name)
    # categories = Category.joins(:videos).distinct.order(:name)
    # videos = Video.all.order(:title)

    # @categories_videos = categories.each_with_object({}) do |category, obj|
    #   obj[category] = []
    # end

    # videos.each do |video|
    #   @categories_videos[video.category] << video
    # end
  end

  def show
    @crap = 'cool'
    @video = Video.find params[:id]
  end

  def search
    @videos = Video.search_by_title(params[:search_term])
  end
end
