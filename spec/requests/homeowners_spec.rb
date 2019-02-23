require 'rails_helper'

RSpec.describe "Homeowners", type: :request do
  describe "GET /homeowners" do
    it "works! (now write some real specs)" do
      get homeowners_path
      expect(response).to have_http_status(200)
    end
  end
end
