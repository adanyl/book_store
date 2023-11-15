class Book < ApplicationRecord
  has_many :reviews, dependent: :destroy
	has_many :order_items
end
  