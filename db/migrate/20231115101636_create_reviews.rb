class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.references :book, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :rating
      t.text :comment

      t.timestamps
    end
  end
end
