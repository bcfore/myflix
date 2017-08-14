require 'spec_helper'

describe SessionsController do
  describe 'GET new' do
    it "redirects to 'home' for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end

    it "renders the new template for unauthenticated users" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do
    let (:valid_user) { Fabricate(:user) }
    before { post :create, credentials }

    context "with valid credentials" do
      let(:credentials) do
        { email: valid_user.email, password: valid_user.password }
      end

      it "sets the session[:user_id]" do
        expect(session[:user_id]).to eq(valid_user.id)
      end

      it "creates a flash-info message" do
        expect(flash[:info]).to be
        # Kevin's:
        expect(flash[:info]).not_to be_blank
      end

      it "redirects to 'home'" do
        expect(response).to redirect_to home_path
      end
    end

    context "with invalid credentials" do
      let(:credentials) do
        { email: valid_user.email, password: '' }
      end

      it "does not set the session[:user_id]" do
        expect(session[:user_id]).to be_nil
      end

      it "creates a flash-danger message" do
        expect(flash[:danger]).to be
      end

      it "re-renders the 'new' view" do
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET destroy' do
    it "redirects to 'root' for unauthenticated users" do
      get :destroy
      expect(response).to redirect_to root_path
    end

    context "with authenticated user" do
      before do
        session[:user_id] = Fabricate(:user).id
        get :destroy
      end

      it "sets the session[:user_id] to nil" do
        expect(session[:user_id]).to be_nil
      end

      it "creates a flash-info message" do
        expect(flash[:info]).to be
      end

      it "redirects to 'root'" do
        expect(response).to redirect_to root_path
      end
    end
  end
end
