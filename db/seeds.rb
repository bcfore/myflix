# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# To reset the sequences:
# ActiveRecord::Base.connection.tables.each do |t|
#   ActiveRecord::Base.connection.reset_pk_sequence!(t)
# end

User.all.delete_all
Category.all.delete_all
Video.all.delete_all
QueuedUserVideo.all.delete_all
Review.all.delete_all

user1 = User.create(email: 'bcf@bcf', password: 'bcf', full_name: 'bcf')
user2 = User.create(email: 'qwer@qwer', password: 'qwer', full_name: 'Ty Qwer')

cat1 = Fabricate(:category, name: 'Comedy')
cat2 = Fabricate(:category, name: 'Drama')
cat3 = Fabricate(:category, name: 'Reality TV')

url1 = '/tmp/monk.jpg'
url2 = '/tmp/monk_large.jpg'

Fabricate.times(7, :video,
                small_cover_url: url1,
                large_cover_url: url2,
                category: cat1)

Fabricate.times(2, :video,
                small_cover_url: url1,
                large_cover_url: url2,
                category: cat2)

Fabricate.times(10, :video,
                small_cover_url: url1,
                large_cover_url: url2,
                category: cat3)

first_video = cat1.recent_videos.first
first_video.update title: 'The Simpsons'

Fabricate.times(2, :review, video: first_video, user: user1)
Fabricate.times(3, :review, video: first_video, user: user2)
Fabricate.times(5, :review, video: first_video, user: user1)

QueuedUserVideo.insert!(user1, first_video)
QueuedUserVideo.insert!(user1, cat2.recent_videos.first)
QueuedUserVideo.insert!(user1, cat3.recent_videos.first)

