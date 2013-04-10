# This migration comes from minitweet (originally 20130410061156)
class CreateMinitweetRelationships < ActiveRecord::Migration
  def change
    create_table :minitweet_relationships do |t|
      t.integer :followed_id
      t.integer :follower_id

      t.timestamps
    end
  end
end
