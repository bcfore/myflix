require 'spec_helper'

describe UsersController do
  describe 'GET new' do
    it "sets @user to a new User instance" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  # Note to bcf -- as per Kevin's sol'n, it would have been
  # easier to use 'Fabricator.attributes_for(:user)' to build
  # the params[:user] hash.

  describe 'POST create' do
    let(:user_params) do
      {
        user: {
          email: unsaved_user.email,
          full_name: unsaved_user.full_name,
          password: unsaved_user.password
        }
      }
    end

    before { post :create, user_params }

    context "with valid user parameters" do
      let (:unsaved_user) { Fabricate.build(:user) }

      it "assigns user_params' email, full_name and password to @user" do
        expect(assigns(:user).email).to eq(unsaved_user.email)
        expect(assigns(:user).full_name).to eq(unsaved_user.full_name)
        expect(assigns(:user).password).to eq(unsaved_user.password)
        # Kevin's spec is just this:
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "persists @user" do
        the_user = User.find_by email: unsaved_user.email
        expect(the_user).to be
        # Kevin's spec:
        expect(User.count).to eq(1)
      end

      it "redirects to the sign_in path" do
        expect(response).to redirect_to sign_in_path
      end
    end

    context "with invalid user parameters" do
      let (:unsaved_user) { Fabricate.build(:user, password: '') }

      it "assigns user_params' email, full_name and password to @user" do
        expect(assigns(:user).email).to eq(unsaved_user.email)
        expect(assigns(:user).full_name).to eq(unsaved_user.full_name)
        expect(assigns(:user).password).to eq(unsaved_user.password)
        # Kevin's spec is just this:
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "does not persist @user" do
        the_user = User.find_by email: unsaved_user.email
        expect(the_user).not_to be
        # Kevin's spec:
        expect(User.count).to eq(0)
      end

      it "re-renders the 'new' template" do
        expect(response).to render_template :new
      end

      it "creates a flash-danger message" do
        expect(flash[:danger]).to be
      end
    end
  end
end
