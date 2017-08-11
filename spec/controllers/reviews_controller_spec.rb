require 'spec_helper'

describe ReviewsController do
  describe 'POST create' do
    let(:video) { Fabricate(:video) }

    it "redirects to root for unauthenticated users" do
      video = Fabricate(:video)
      post :create, id: video.id
      expect(response).to redirect_to root_path
    end

    context "with authenticated user" do
      before { session[:user_id] = Fabricate(:user).id }

      context "with valid review params" do
        it ""
      end

    end
  end
end
