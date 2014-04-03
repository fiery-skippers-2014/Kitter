class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |col|
      col.belongs_to :user
      col.string :user_name

      col.timestamps
    end
  end
end
