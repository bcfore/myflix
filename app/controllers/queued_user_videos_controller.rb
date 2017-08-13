class QueuedUserVideosController < ApplicationController
  before_action :require_user

  def index
    @queue = current_user.queued_user_videos.all
  end

  def create
    QueuedUserVideo.insert! current_user, Video.find(params[:id])
    redirect_to my_queue_path
  end

  def destroy
    QueuedUserVideo.remove! current_user, Video.find(params[:id])
    redirect_to my_queue_path
  end
end
