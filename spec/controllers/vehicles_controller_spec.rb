require 'rails_helper'

RSpec.describe VehiclesController, type: :controller do
  describe "GET index" do
    it "renders the main page" do
      get :index
      expect(response).to render_template(:index)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST search" do
    it "redirects to index page" do
      post :search, params: { query: 'abc' }
      expect(response).to redirect_to(root_url(query: 'abc'))
      expect(response).to have_http_status(302)
    end
  end
end
