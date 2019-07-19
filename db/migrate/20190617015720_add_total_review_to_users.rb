class AddTotalReviewToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :total_review, :integer, default: 0
  end
end
