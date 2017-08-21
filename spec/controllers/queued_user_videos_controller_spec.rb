require 'spec_helper'

describe QueuedUserVideosController do
  describe 'GET index' do
    it "redirects to the root path for unauthenticated users" do
      get :index
      expect(response).to redirect_to root_path
    end

    context "with authenticated users" do
      let(:user) { Fabricate(:user) }

      before do
        session[:user_id] = user.id
        get :index
      end

      context "with 0 videos in queue" do
        it "sets @queue" do
          expect(assigns(:queue)).to eq([])
        end
      end

      context "with >0 videos in queue" do
        before do
          QueuedUserVideo.insert! user, Fabricate(:video)
          QueuedUserVideo.insert! user, Fabricate(:video)
        end

        it "sets @queue" do
          expect(assigns(:queue).size).to eq(2)
        end
      end
    end
  end

  describe 'POST create' do
    let(:video) { Fabricate(:video) }

    it "redirects to the root path for unauthenticated users" do
      post :create, id: video.id
      expect(response).to redirect_to root_path
    end

    context "with authenticated users" do
      let(:user) { Fabricate(:user) }

      before do
        session[:user_id] = user.id
        post :create, id: video.id
      end

      it "redirects to 'my_queue'" do
        expect(response).to redirect_to my_queue_path
      end

      it "adds the video to the users's queue" do
        expect(user.queued_user_videos.size).to eq(1)
      end
    end
  end

  describe 'POST update_queue' do
    it "redirects to the root path for unauthenticated users" do
      post :update_queue
      expect(response).to redirect_to root_path
    end

    context "with authenticated users" do
      let(:user) { Fabricate(:user) }

      before do
        session[:user_id] = user.id
      end

      context "with no videos in queue" do
        before do
          post :update_queue
        end

        it "redirects to 'my_queue'" do
          expect(response).to redirect_to my_queue_path
        end
      end

      context "with one video in queue" do
        let(:item1) { QueuedUserVideo.insert! user, Fabricate(:video) }
        let(:new_positions) { { item1.id.to_s => new_position.to_s } }

        before do
          post :update_queue, new_positions: new_positions
        end

        context "with new_position = 1" do
          let(:new_position) { 1 }

          it "redirects to 'my_queue'" do
            expect(response).to redirect_to my_queue_path
          end

          it "leaves the position at 1" do
            expect(user.queued_user_videos.first.place_in_queue).to eq(1)
          end
        end

        context "with new_position > 1" do
          let(:new_position) { 5 }

          it "redirects to 'my_queue'" do
            expect(response).to redirect_to my_queue_path
          end

          it "leaves the position at 1" do
            expect(user.queued_user_videos.first.place_in_queue).to eq(1)
          end
        end

        context "with non-integer new_position" do
          let(:new_position) { 1.1 }

          it "redirects to 'my_queue'" do
            expect(response).to redirect_to my_queue_path
          end

          it "leaves the position at 1" do
            expect(user.queued_user_videos.first.place_in_queue).to eq(1)
          end

          it "creates a flash-danger message" do
            expect(flash[:danger]).to be
          end
        end
      end

      context "with two videos in queue" do
        let(:item1) { QueuedUserVideo.insert! user, Fabricate(:video) }
        let(:item2) { QueuedUserVideo.insert! user, Fabricate(:video) }
        let(:new_positions_param) {
          {
            item1.id.to_s => new_positions.first.to_s,
            item2.id.to_s => new_positions.last.to_s
          }
        }

        before do
          post :update_queue, new_positions: new_positions_param
        end

        context "with new_positions = [1, 2]" do
          let(:new_positions) { [1, 2] }

          it "leaves the queue unaffected" do
            expect(user.queued_user_videos.first.id).to eq(item1.id)
            expect(user.queued_user_videos.last.id).to eq(item2.id)
          end
        end

        context "with new_positions = [-1, 10]" do
          let(:new_positions) { [-1, 10] }

          it "leaves the queue unaffected" do
            expect(user.queued_user_videos.first.id).to eq(item1.id)
            expect(user.queued_user_videos.last.id).to eq(item2.id)
          end
        end

        context "with new_positions = [2, 1]" do
          let(:new_positions) { [2, 1] }

          it "reverses the queue order" do
            expect(user.queued_user_videos.first.id).to eq(item2.id)
            expect(user.queued_user_videos.last.id).to eq(item1.id)
          end
        end

        context "with new_positions = [10, -1]" do
          let(:new_positions) { [10, -1] }

          it "reverses the queue order" do
            expect(user.queued_user_videos.first.id).to eq(item2.id)
            expect(user.queued_user_videos.last.id).to eq(item1.id)
          end
        end

        context "with new_positions = [1, 1]" do
          let(:new_positions) { [1, 1] }

          it "leaves the queue unaffected" do
            expect(user.queued_user_videos.first.id).to eq(item1.id)
            expect(user.queued_user_videos.last.id).to eq(item2.id)
          end

          it "creates a flash-danger message" do
            expect(flash[:danger]).to be
          end
        end
      end

      context "with one rated video, one non-rated video" do
        let(:video1) { Fabricate(:video) }
        let(:item1) { QueuedUserVideo.insert! user, video1 }
        let(:item2) { QueuedUserVideo.insert! user, Fabricate(:video) }
        let(:ratings_params) { [
          { "id" => item1.id.to_s, "rating" => new_ratings[0].to_s },
          { "id" => item2.id.to_s, "rating" => new_ratings[1].to_s }
        ] }

        before do
          Fabricate(:review, user: user, video: video1, rating: 4)
          post :update_queue, ratings: ratings_params
        end

        context "with new_ratings = [4, '']" do
          let(:new_ratings) { [4, ''] }

          it "leaves the ratings unaffected" do
            expect(user.queued_user_videos.first.rating).to eq(4)
            expect(user.queued_user_videos.last.rating).to be_nil
          end
        end

        context "with new_ratings = [5, '']" do
          let(:new_ratings) { [5, ''] }

          it "sets the new rating for the existing review" do
            expect(user.queued_user_videos.first.rating).to eq(5)
            expect(user.queued_user_videos.last.rating).to be_nil
          end
        end

        context "with new_ratings = [5, 2]" do
          let(:new_ratings) { [5, 2] }

          it "sets the new ratings (creates a new review for video2)" do
            expect(user.queued_user_videos.first.rating).to eq(5)
            expect(user.queued_user_videos.last.rating).to eq(2)
          end
        end
      end
    end
  end

  describe 'DELETE destroy' do
    let(:video) { Fabricate(:video) }

    it "redirects to the root path for unauthenticated users" do
      delete :destroy, id: video.id
      expect(response).to redirect_to root_path
    end

    context "with authenticated users" do
      let(:user) { Fabricate(:user) }

      before do
        session[:user_id] = user.id
        QueuedUserVideo.insert! user, video
        QueuedUserVideo.insert! user, Fabricate(:video)
        delete :destroy, id: video.id
      end

      it "redirects to 'my_queue'" do
        expect(response).to redirect_to my_queue_path
      end

      it "removes the video from the users's queue" do
        expect(user.queued_user_videos.size).to eq(1)
      end
    end
  end
end
