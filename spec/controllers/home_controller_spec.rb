require 'spec_helper'

describe HomeController do

  describe "user singed in" do
    let(:user) { FactoryGirl.create(:user, username: "homeindexuser", email:"home@example.com") }
    before { sign_in user }
    it "home page" do
      get :index
    end
  end

end