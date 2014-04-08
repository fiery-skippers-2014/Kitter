class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |col|
      col.belongs_to  :user  #CR USE AR :class_name and :foreign_key attributes to help create this relationship -
      #CR - see https://github.com/raorao/active-raocord/ for an example
      col.string      :user_name

      col.timestamps
    end
  end
end
