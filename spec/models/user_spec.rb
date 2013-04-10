require "spec_helper"

describe User do

  before do
    @user = User.new(username: "tester", email: "testre@example.com", password: "password", password_confirmation: "password")
  end

  subject { @user }

  it{ should respond_to(:username) }
  it{ should respond_to(:email) }
  it{ should respond_to(:password) }
  it{ should respond_to(:password_confirmation) }
  it{ should respond_to(:remember_me) }
  it{ should respond_to(:created_at) }
  it{ should respond_to(:updated_at) }
  it{ should respond_to(:relationships) }
  it{ should respond_to(:reverse_relationships) }
  it{ should respond_to(:followed_users) }
  it{ should respond_to(:followers) }
  #it{ should respond_to(:posts) }
  it{ should respond_to(:following?) }
  it{ should respond_to(:follow!) }
  it{ should respond_to(:unfollow!) }

  it { should be_valid }

  #describe "with active attribute set to 'true'" do
  #  it { should be_active }
  #end
  #
  describe "when username is not present" do
    before { @user.username = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.username = "a" * 50 }
    it { should_not be_valid }
  end
  #
  describe "when email format is invalid" do
    it "should be invalid" do
      emails = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      emails.each do |invalid_emails|
        @user.email = invalid_emails
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  describe "when email is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password = @user.password_confirmation = "abc" }
    it { should_not be_valid }
  end


  #describe "post associations" do
  #
  #  before { @user.save }
  #  let!(:older_post) do
  #    FactoryGirl.create(:post, user: @user, created_at: 1.day.ago)
  #  end
  #  let!(:newer_post) do
  #    FactoryGirl.create(:post, user: @user, created_at: 1.hour.ago)
  #  end
  #
  #  it "should have the right posts in the right order" do
  #    @user.posts.should == [newer_post, older_post]
  #  end
  #
  #  it "should destroy associated posts" do
  #    posts = @user.posts
  #    @user.destroy
  #    posts.each do |post|
  #      Post.find_by_id(post.id).should be_nil
  #    end
  #  end

    #describe "status" do
    #  let(:unfollowed_post) do
    #    FactoryGirl.create(:post, user: FactoryGirl.create(:user, username: 'unfollowed', email: 'unfollowed@example.com'))
    #  end
    #  let(:followed_user) { FactoryGirl.build(:user, username: 'followed', email: 'followed@example.com') }
    #
    #  before do
    #    @user.save()
    #    followed_user.save()
    #    @user.follow!(followed_user)
    #    3.times { followed_user.posts.create!(content: "Lorem ipsum") }
    #  end
    #
    #  its(:feed) { should include(older_post) }
    #  its(:feed) { should include(newer_post) }
    #  its(:feed) { should_not include(unfollowed_post) }
    #  its(:feed) do
    #    followed_user.posts.each do |post|
    #      should include(post)
    #    end
    #  end
    #end

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user, username: 'other1', email: 'other1@example.com') }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end

    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end

end