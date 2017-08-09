require 'spec_helper'

describe VideosController do
  describe 'GET show' do
    it "redirects to the root path for unauthenticated users" do
      video = Fabricate(:video)
      get :show, { id: video.id.to_s }
      expect(response).to redirect_to root_path
    end

    context "with authenticated user" do
      before do
        session[:user_id] = Fabricate(:user).id
      end

      it "sets @video" do
        video = Fabricate(:video)
        # Note, you don't need the brackets around 'id: ...' here:
        get :show, { id: video.id.to_s }
        expect(assigns(:video)).to eq(video)
      end

      # He argues that this test isn't really needed, since it's built-in Rails:
      it "renders the show template" do
        video = Fabricate(:video)
        get :show, { id: video.id.to_s }
        expect(response).to render_template :show
      end
    end
  end

  describe 'GET search' do
    it "redirects to the root path for unauthenticated users" do
      video = Fabricate(:video)
      search_term = video.title
      get :search, { search_term: search_term }
      expect(response).to redirect_to root_path
    end

    context "with authenticated user" do
      before do
        session[:user_id] = Fabricate(:user).id
      end

      it "sets the @videos variable according to the search" do
        # Kevin's version:
        #
        # futurama = Fabricate(:video, title: 'Futurama')
        # get :search, search_term: 'rama'
        # expect(assigns(:videos)).to eq([futurama])

        # BCF version:
        video = Fabricate(:video)
        search_term = video.title
        search_result = Video.search_by_title(search_term)
        get :search, { search_term: search_term }
        expect(assigns(:videos)).to eq(search_result)
      end

      # Again, he argues this one isn't really necessary:
      it "renders the search template" do
        video = Fabricate(:video)
        search_term = video.title
        get :search, { search_term: search_term }
        expect(response).to render_template :search
      end
    end
  end
end
