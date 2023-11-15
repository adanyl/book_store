FactoryBot.define do
  factory :review do
    comment { 'This is a great book!' }
    rating { 5 }
    association :book
    association :user
  end
end
