class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user

	validates :book_id, uniqueness: { scope: :user_id }
  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
end
