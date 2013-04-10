# This migration comes from minitweet (originally 20130409172449)
class AddUserIdToMinitweetPosts < ActiveRecord::Migration
  def change
    add_column :minitweet_posts, :user_id, :integer
  end
end
