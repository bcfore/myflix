class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.text :body
      t.timestamps
      t.integer :user_id
      t.integer :video_id
    end
  end
end
