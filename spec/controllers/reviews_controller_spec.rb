require 'spec_helper'

describe ReviewsController do
  describe 'POST create' do
    let(:video) { Fabricate(:video) }

    it "redirects to root for unauthenticated users" do
      post :create, video_id: video.id
      expect(response).to redirect_to root_path
    end

    context "with authenticated user" do
      let(:user) { Fabricate(:user) }
      let(:params) do
        {
          video_id: video.id,
          review: review_params
        }
      end
      before do
        session[:user_id] = user.id
        post :create, params
      end

      context "with valid review params" do
        let (:review_params) { Fabricate.attributes_for(:review) }

        it "associates the current user with the review" do
          expect(assigns(:review).user).to eq(user)
        end

        it "associates the current video with the review" do
          expect(assigns(:review).video).to eq(video)
        end

        it "persists @review" do
          expect(Review.count).to eq(1)
        end

        it "sets a flash-info message" do
          expect(flash[:info]).to be
        end

        it "refreshes the video show page (via a redirect)" do
          expect(response).to redirect_to video
        end
      end

      context "with invalid review params" do
        let (:review_params) { Fabricate.attributes_for(:review, rating: 0) }

        it "sets @video" do
          expect(assigns(:video)).to eq(video)
        end

        it "does not persist @review" do
          expect(Review.count).to be_zero
        end

        it "sets a flash-danger message" do
          expect(flash[:danger]).to be
        end

        it "renders the video's show template" do
          expect(response).to render_template "videos/show"
        end
      end
    end
  end
end
