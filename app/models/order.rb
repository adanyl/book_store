class Order < ApplicationRecord
	belongs_to :user
	has_many :order_items, dependent: :destroy

	validates :total_price, presence: true

	enum :status, [:draft, :pending, :completed]

	before_save :update_total_price

  def update_total_price
    self.total_price = calculate_total_price
  end

  def calculate_total_price
    order_items.sum(&:item_price)
  end
end