class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |col|
      col.belongs_to  :user
      col.string      :user_name

      col.timestamps
    end
  end
end
