class AddReviewIdToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :review_id, :integer
  end
end
