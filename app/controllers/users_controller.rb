class UsersController < ApplicationController

  #http_basic_authenticate_with :name => "dhh", :password => "secret", :except => [:new]
  before_filter :authenticate_user!

  def index
    #@users = User.all
    user_signed_in?
    
    @users = User.paginate(:page => params[:page], :per_page => 10)

  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    
    if @user.save
        flash[:notice] = "You Signed up successfully"
        flash[:color]= "valid"
        redirect_to :action => "new"
    else
        flash[:notice] = "Form is invalid"
        flash[:color]= "invalid"
        render :action => "new"
    end
  end

  def show
    @user = User.find(params[:id])
    @post = @user.posts.build
    @posts = @user.posts.paginate(:page => params[:page])

    @default_post_text=''
    if current_user!=@user
      @default_post_text= "@" + @user.username
    end

    respond_to do |format|
    	format.html  # show.html.erb
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(:page => params[:page], :per_page => 5)
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page], :per_page => 5)
    render 'show_follow'
  end

end
