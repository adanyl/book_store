FactoryBot.define do
  factory :book do
    author { 'John Doe' }
    genre { 'Fiction' }
    price { 19.99 }
    published_year { 2020 }
    title { 'Sample Book' }
  end
end
