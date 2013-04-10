# This migration comes from minitweet (originally 20130409110506)
class CreateMinitweetPosts < ActiveRecord::Migration
  def change
    create_table :minitweet_posts do |t|
      t.text :content

      t.timestamps
    end
  end
end
