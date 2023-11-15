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
