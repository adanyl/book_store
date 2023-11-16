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
FactoryBot.define do
  factory :order do
    status { 'draft' }
    total_price { 0.0 }
    association :user

    factory :order_with_items do
      transient do
        order_items_count { 3 }
      end

      after(:create) do |order, evaluator|
        create_list(:order_item, evaluator.order_items_count, order: order)
        order.update_total_price
      end
    end
  end
end
