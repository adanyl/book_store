# == Schema Information
#
# Table name: books
#
#  id             :bigint           not null, primary key
#  author         :string           not null
#  genre          :string
#  price          :float            not null
#  published_year :integer
#  title          :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :book do
    author { 'John Doe' }
    genre { 'Fiction' }
    price { 19.99 }
    published_year { 2020 }
    title { 'Sample Book' }
  end
end
