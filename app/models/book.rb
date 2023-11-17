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
class Book < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :order_items

  validates :title, :price, :author, presence: true

  validates :price, presence: true, numericality: { greater_than: 0 }

  scope :bought_by_user, lambda { |user_id|
    joins(order_items: { order: :user })
      .where(users: { id: user_id })
      .where(orders: { status: :pending })
      .distinct
  }
end
