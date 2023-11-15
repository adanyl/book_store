class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  validates :total_price, presence: true
  validate :one_draft_order, on: :create

  enum :status, %i[draft pending completed]

  before_save :update_total_price

  private

  def one_draft_order
    return unless user && user.orders.exists?(status: 'draft')

    errors.add(:base, 'User can have only one order in draft status')
  end

  def update_total_price
    self.total_price = calculate_total_price
  end

  def calculate_total_price
    order_items.sum(&:item_price)
  end
end
