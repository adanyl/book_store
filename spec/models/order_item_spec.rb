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
require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      order_item = build(:order_item)
      expect(order_item).to be_valid
    end

    it 'is not valid without a quantity' do
      order_item = build(:order_item, quantity: nil)
      expect(order_item).not_to be_valid
      expect(order_item.errors[:quantity]).to include("can't be blank")
    end

    it 'is not valid with a non-positive quantity' do
      order_item = build(:order_item, quantity: 0)
      expect(order_item).not_to be_valid
      expect(order_item.errors[:quantity]).to include('must be greater than 0')
    end

    it 'is not valid without an item_price' do
      order_item = build(:order_item, item_price: nil)
      expect(order_item).not_to be_valid
      expect(order_item.errors[:item_price]).to include("can't be blank")
    end
  end

  describe 'Associations' do
    it 'belongs to an order' do
      association = described_class.reflect_on_association(:order)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to a book' do
      association = described_class.reflect_on_association(:book)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe 'Foreign Keys' do
    it 'deletes associated order items when the order is deleted' do
      order = create(:order)
      order_item = create(:order_item, order: order)

      expect { order.destroy }.to change { OrderItem.count }.by(-1)
    end

    it 'deletes associated order items when the book is deleted' do
      book = create(:book)
      order_item = create(:order_item, book: book)

      expect { book.destroy }.to change { OrderItem.count }.by(-1)
    end
  end
end
