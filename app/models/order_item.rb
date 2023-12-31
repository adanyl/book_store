# == Schema Information
#
# Table name: order_items
#
#  id         :bigint           not null, primary key
#  item_price :float
#  quantity   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  book_id    :bigint
#  order_id   :bigint
#
# Indexes
#
#  index_order_items_on_book_id   (book_id)
#  index_order_items_on_order_id  (order_id)
#
# Foreign Keys
#
#  fk_rails_...  (book_id => books.id) ON DELETE => cascade
#  fk_rails_...  (order_id => orders.id) ON DELETE => cascade
#
class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :book

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :item_price, presence: true
end
