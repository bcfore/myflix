class QueuedUserVideosController < ApplicationController
  before_action :require_user

  def index
    @queue = current_user.queued_user_videos.all
  end

  def create
    QueuedUserVideo.insert! current_user, Video.find(params[:id])
    redirect_to my_queue_path
  end

  def update_queue
    # See your notes for how to do this via a transaction.
    QueuedUserVideo.update_ratings!(current_user, params[:ratings])

    if !QueuedUserVideo.update_positions!(current_user, params[:new_positions])
      flash[:danger] = "The new list orders must be valid integers."
    end
    redirect_to my_queue_path
  end

  def destroy
    QueuedUserVideo.remove! current_user, Video.find(params[:id])
    redirect_to my_queue_path
  end
end
