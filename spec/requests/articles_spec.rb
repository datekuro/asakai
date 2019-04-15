require 'rails_helper'

RSpec.describe "Articles", type: :request do
  context "not logged_in" do
    describe "GET /articles" do
      it "works! (now write some real specs)" do
        get articles_path
        expect(response).to have_http_status(302)
      end
    end
  end

end
