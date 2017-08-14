class CreateUserVideoQueue < ActiveRecord::Migration
  def change
    # create_table :user_video_queues do |t|
    create_table :queued_user_videos do |t|
      t.integer :user_id
      t.integer :video_id
      t.integer :place_in_queue
      t.timestamps
    end
  end
end
