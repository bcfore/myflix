require 'spec_helper'

describe User do
  it { should have_many(:reviews) }
  it { should have_many(:queued_user_videos).order('place_in_queue') }
  # it do
  #   should have_many(:queued_videos).
  #     through(:queued_user_videos).
  #     source(:video).
  #     order('queued_user_videos.place_in_queue')
  # end

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:full_name) }
  it { should have_secure_password }
  it { should validate_presence_of(:password).on(:create) }
  # it { should validate_length_of(:password).is_at_least(2).on(:create) }

  # describe '#fetch_review' do
  #   let(:user) { Fabricate(:user) }
  #   let(:video) { Fabricate(:video) }
  #   subject { user.fetch_rating(video) }

  #   context 'video not reviewed by user' do
  #     it "returns nil if video has no reviews" do
  #       expect(subject).to be_nil
  #     end

  #     it "returns nil if video has a review not from this user" do
  #       user2 = Fabricate(:user)
  #       Fabricate(:review, user: user2, video: video)
  #       expect(subject).to be_nil
  #     end
  #   end

  #   context "video reviewed by user" do
  #     it "returns the user's rating" do
  #       Fabricate(:review, user: user, video: Fabricate(:video), rating: 5)
  #       Fabricate(:review, user: user, video: Fabricate(:video), rating: 5)
  #       Fabricate(:review, user: user, video: Fabricate(:video), rating: 5)
  #       review = Fabricate(:review, user: user, video: video, rating: 3)
  #       expect(subject).to eq(3)
  #     end
  #   end
  # end

  # describe '#insert_in_queue!' do
  #   let(:user) { Fabricate(:user) }
  #   subject { user.queued_videos }

  #   context '0 videos already in queue' do
  #     it 'adds the video to the queue' do
  #       v = Fabricate(:video)
  #       user.insert_in_queue! v
  #       expect(subject).to eq([v])
  #     end
  #   end

  #   context '1 video already in queue' do
  #     let(:v1) { Fabricate(:video) }
  #     let(:v2) { Fabricate(:video) }
  #     before { user.insert_in_queue! v1 }

  #     it 'inserts at tail if position is not specified' do
  #       user.insert_in_queue! v2
  #       expect(subject).to eq([v1, v2])
  #     end

  #     it 'inserts at tail for position = 2' do
  #       user.insert_in_queue! v2, 2
  #       expect(subject).to eq([v1, v2])
  #     end

  #     it 'inserts at tail for position > 2' do
  #       user.insert_in_queue! v2, 10
  #       expect(subject).to eq([v1, v2])
  #     end

  #     it 'inserts at front for position = 1' do
  #       user.insert_in_queue! v2, 1
  #       expect(subject).to eq([v2, v1])
  #     end

  #     it 'inserts at front for position < 1' do
  #       user.insert_in_queue! v2, -1
  #       expect(subject).to eq([v2, v1])
  #     end
  #   end

  #   context '2 videos already in queue' do
  #     let(:v1) { Fabricate(:video) }
  #     let(:v2) { Fabricate(:video) }
  #     let(:v3) { Fabricate(:video) }
  #     before do
  #       user.insert_in_queue! v1
  #       user.insert_in_queue! v2
  #     end

  #     it 'inserts at tail if position is not specified' do
  #       user.insert_in_queue! v3
  #       expect(subject).to eq([v1, v2, v3])
  #     end

  #     it 'inserts at tail for position = 3' do
  #       user.insert_in_queue! v3, 3
  #       expect(subject).to eq([v1, v2, v3])
  #     end

  #     it 'inserts at tail for position > 3' do
  #       user.insert_in_queue! v3, 10
  #       expect(subject).to eq([v1, v2, v3])
  #     end

  #     it 'inserts at front for position = 1' do
  #       user.insert_in_queue! v3, 1
  #       expect(subject).to eq([v3, v1, v2])
  #     end

  #     it 'inserts at front for position < 1' do
  #       user.insert_in_queue! v3, -1
  #       expect(subject).to eq([v3, v1, v2])
  #     end

  #     it 'inserts in the middle for position = 2' do
  #       user.insert_in_queue! v3, 2
  #       expect(subject).to eq([v1, v3, v2])
  #     end

  #     it "doesn't insert the video if it's already in the queue" do
  #       user.insert_in_queue! v1
  #       expect(subject).to eq([v1, v2])
  #     end
  #   end
  # end
end
