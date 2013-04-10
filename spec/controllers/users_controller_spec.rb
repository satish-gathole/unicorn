require "spec_helper"
include Devise::TestHelpers

describe UsersController do

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "Sing up User"  do
    it "create new user" do
      expect {
        post :create, {:user => {:username => "newuser1", :email => "newuser1@example.com", :password => "password", :password_confirmation => "password"}}
      }.to change(User, :count).by(1)

    end

    it "should not create new user" do
      expect {
        post :create, {:user => {:email => "newuser1@example.com", :password => "password", :password_confirmation => "password"}}
      }.to change(User, :count).by(0)

    end

    describe "show user profile" do

      newuser2 = User.create(:username => "newuser2", :email => "newuser2@example.com", :password => "password", :password_confirmation => "password")

      it "show" do
        get :show, :id => newuser2.id
      end

      it "users list" do
        get :index
      end

      it "new user" do
        get :new
      end

      it "followed list" do
        get :following, :id => user.id
      end

      it "followers list" do
        get :followers, :id => user.id
      end
    end
  end
end