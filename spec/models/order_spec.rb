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
require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      order = build(:order)
      expect(order).to be_valid
    end

    it 'is not valid without a total_price' do
      order = build(:order, total_price: nil)
      expect(order).not_to be_valid
      expect(order.errors[:total_price]).to include("can't be blank")
    end

    it 'validates one draft order per user' do
      user = create(:user)
      create(:order, user: user, status: 'draft') # Existing draft order

      order = build(:order, user: user, status: 'draft')
      expect(order).not_to be_valid
      expect(order.errors[:base]).to include('User can have only one order in draft status')
    end
  end

  describe 'Associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'has many order items' do
      association = described_class.reflect_on_association(:order_items)
      expect(association.macro).to eq :has_many
    end

    it 'destroys dependent order items' do
      order = create(:order)
      order_item = create(:order_item, order: order)

      expect { order.destroy }.to change { OrderItem.count }.by(-1)
    end
  end

  describe 'Callbacks' do
    it 'updates total price before saving' do
      order = create(:order)
      create(:order_item, order: order, item_price: 50.0)
      create(:order_item, order: order, item_price: 30.0)

      expect { order.save! }.to change { order.reload.total_price }.to(80.0)
    end
  end

  describe 'Enums' do
    it 'has draft, pending, and completed status' do
      expect(Order.statuses).to eq('draft' => 0, 'pending' => 1, 'completed' => 2)
    end
  end
end
