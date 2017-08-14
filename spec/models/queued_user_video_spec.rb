require 'spec_helper'

describe QueuedUserVideo do
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  context "accessor methods" do
    let (:user) { Fabricate(:user) }
    let (:cat) { Fabricate(:category, name: 'Comedy') }
    let (:video) { Fabricate(:video, title: 'Test title', category: cat)}
    let (:queue_item) { Fabricate(:queued_user_video, user: user, video: video) }

    describe '#video_title' do
      it "returns the video's title" do
        expect(queue_item.video_title).to eq('Test title')
      end
    end

    describe '#rating' do
      it "returns nil if the user has not reviewed the video" do
        expect(queue_item.rating).to be_nil
      end

      it "returns the user's rating for the video, if the user has reviewed the video" do
        Fabricate(:review, user: user, video: video, rating: 4)
        expect(queue_item.rating).to eq(4)
      end
    end

    describe '#category' do
      it "returns the video's category (object)" do
        expect(queue_item.category).to eq(cat)
      end
    end

    describe '#category_name' do
      it "returns the video's category's name" do
        expect(queue_item.category_name).to eq('Comedy')
      end
    end
  end

  describe '#insert!' do
    let(:user) { Fabricate(:user) }
    subject { user.queued_user_videos.all.map &:video }

    context '0 videos already in queue' do
      it 'adds the video to the queue' do
        v = Fabricate(:video)
        QueuedUserVideo.insert! user, v
        expect(subject).to eq([v])
      end
    end

    context '1 video already in queue' do
      let(:v1) { Fabricate(:video) }
      let(:v2) { Fabricate(:video) }
      before { QueuedUserVideo.insert! user, v1 }

      it 'inserts at tail if position is not specified' do
        QueuedUserVideo.insert! user, v2
        expect(subject).to eq([v1, v2])
      end

      it 'inserts at tail for position = 2' do
        QueuedUserVideo.insert! user, v2, 2
        expect(subject).to eq([v1, v2])
      end

      it 'inserts at tail for position > 2' do
        QueuedUserVideo.insert! user, v2, 10
        expect(subject).to eq([v1, v2])
      end

      it 'inserts at front for position = 1' do
        QueuedUserVideo.insert! user, v2, 1
        expect(subject).to eq([v2, v1])
      end

      it 'inserts at front for position < 1' do
        QueuedUserVideo.insert! user, v2, -1
        expect(subject).to eq([v2, v1])
      end

      it "doesn't insert the video if it's already in the queue" do
        QueuedUserVideo.insert! user, v1
        expect(subject).to eq([v1])
      end
    end

    context '2 videos already in queue' do
      let(:v1) { Fabricate(:video) }
      let(:v2) { Fabricate(:video) }
      let(:v3) { Fabricate(:video) }
      before do
        QueuedUserVideo.insert! user, v1
        QueuedUserVideo.insert! user, v2
      end

      it 'inserts at tail if position is not specified' do
        QueuedUserVideo.insert! user, v3
        expect(subject).to eq([v1, v2, v3])
      end

      it 'inserts at tail for position = 3' do
        QueuedUserVideo.insert! user, v3, 3
        expect(subject).to eq([v1, v2, v3])
      end

      it 'inserts at tail for position > 3' do
        QueuedUserVideo.insert! user, v3, 10
        expect(subject).to eq([v1, v2, v3])
      end

      it 'inserts at front for position = 1' do
        QueuedUserVideo.insert! user, v3, 1
        expect(subject).to eq([v3, v1, v2])
      end

      it 'inserts at front for position < 1' do
        QueuedUserVideo.insert! user, v3, -1
        expect(subject).to eq([v3, v1, v2])
      end

      it 'inserts in the middle for position = 2' do
        QueuedUserVideo.insert! user, v3, 2
        expect(subject).to eq([v1, v3, v2])
      end

      it "doesn't insert the video if it's already in the queue" do
        QueuedUserVideo.insert! user, v1
        expect(subject).to eq([v1, v2])
      end
    end
  end

  describe '#remove!' do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    subject { user.queued_user_videos }

    context '0 videos already in queue' do
      it 'does nothing' do
        QueuedUserVideo.remove! user, video
        expect(subject).to eq([])
      end
    end

    context '1 video already in queue' do
      before { QueuedUserVideo.insert! user, video }

      it 'does nothing if the video is not in the queue' do
        QueuedUserVideo.remove! user, Fabricate(:video)
        expect(subject.size).to eq(1)
      end

      it 'removes the video, if it is in the queue' do
        QueuedUserVideo.remove! user, video
        expect(subject).to eq([])
      end
    end

    context 'several videos already in queue' do
      it 'does nothing if the video is not in the queue' do
        5.times { QueuedUserVideo.insert! user, Fabricate(:video) }
        QueuedUserVideo.remove! user, video
        expect(subject.size).to eq(5)
      end

      context 'with video at back of queue' do
        before do
          5.times { QueuedUserVideo.insert! user, Fabricate(:video) }
          QueuedUserVideo.insert! user, video

          QueuedUserVideo.remove! user, video
        end

        it 'removes the video' do
          expect(subject.pluck :video_id).to_not include(video.id)
        end

        it "the 'place_in_queue' for the remaining queue videos are not affected" do
          expect(subject.pluck :place_in_queue).to eq((1..5).to_a)
        end
      end

      context 'with video at front of queue' do
        before do
          QueuedUserVideo.insert! user, video
          5.times { QueuedUserVideo.insert! user, Fabricate(:video) }

          QueuedUserVideo.remove! user, video
        end

        it 'removes the video' do
          expect(subject.pluck :video_id).to_not include(video.id)
        end

        it "updates the 'place_in_queue' for the remaining videos" do
          expect(subject.pluck :place_in_queue).to eq((1..5).to_a)
        end
      end

      context 'with video in the middle of the queue' do
        before do
          2.times { QueuedUserVideo.insert! user, Fabricate(:video) }
          QueuedUserVideo.insert! user, video
          3.times { QueuedUserVideo.insert! user, Fabricate(:video) }

          QueuedUserVideo.remove! user, video
        end

        it 'removes the video' do
          expect(subject.pluck :video_id).to_not include(video.id)
        end

        it "updates the 'place_in_queue' for the remaining videos" do
          expect(subject.pluck :place_in_queue).to eq((1..5).to_a)
        end
      end
    end
  end
end
