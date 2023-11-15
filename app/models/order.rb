# == Schema Information
#
# Table name: orders
#
#  id          :bigint           not null, primary key
#  status      :integer          default("draft")
#  total_price :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
#
# Indexes
#
#  index_orders_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
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
