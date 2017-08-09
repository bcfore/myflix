require 'spec_helper'

describe VideosController do
  describe 'GET show' do
    it "sets the @videos variable" do
      family_guy = Video.create(title: "Family Guy", description: "A comedy.")

      get :show, { id: family_guy.id.to_s }
      # expect(assigns(:video)).to eq(family_guy)
      expect(assigns(:crap)).to eq(family_guy)
    end

    it "renders the show template"
  end

  describe 'GET search' do

  end
end
