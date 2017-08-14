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
