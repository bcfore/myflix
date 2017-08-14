class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find params[:video_id]
    @review = Review.new(review_params)
    @review.user = current_user
    @review.video = @video

    if @review.save
      flash[:info] = "Thanks for your review!"
      redirect_to @video
    else
      flash[:danger] = "Please check your input."
      render "videos/show"
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :body)
  end
end
