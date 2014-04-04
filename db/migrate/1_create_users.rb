class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |col|
    col.string :full_name
    col.string :user_name
    col.string :email
    col.string :password

    col.timestamps
    end
  end
end
