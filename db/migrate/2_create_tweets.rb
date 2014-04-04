class CreateTweets < ActiveRecord::Migration
  def change
    create_table(:tweets) do |col|
      col.integer    :counter, default: 0
      col.text       :input
      col.belongs_to :user

      col.timestamps
    end
  end
end
