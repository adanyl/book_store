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
require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      book = build(:book)
      expect(book).to be_valid
    end

    it 'is not valid without a title' do
      book = build(:book, title: nil)
      expect(book).not_to be_valid
      expect(book.errors[:title]).to include("can't be blank")
    end

    it 'is not valid without an author' do
      book = build(:book, author: nil)
      expect(book).not_to be_valid
      expect(book.errors[:author]).to include("can't be blank")
    end

    it 'is not valid without a price' do
      book = build(:book, price: nil)
      expect(book).not_to be_valid
      expect(book.errors[:price]).to include("can't be blank")
    end

    it 'is not valid with a non-positive price' do
      book = build(:book, price: 0.0)
      expect(book).not_to be_valid
      expect(book.errors[:price]).to include('must be greater than 0')
    end
  end

  describe 'Associations' do
    it 'has many reviews' do
      association = described_class.reflect_on_association(:reviews)
      expect(association.macro).to eq :has_many
    end

    it 'has many order items' do
      association = described_class.reflect_on_association(:order_items)
      expect(association.macro).to eq :has_many
    end

    it 'destroys dependent reviews' do
      book = create(:book)
      review = create(:review, book: book)

      expect { book.destroy }.to change { Review.count }.by(-1)
    end

    it 'destroys dependent order items' do
      book = create(:book)
      order_item = create(:order_item, book: book)

      expect { book.destroy }.to change { OrderItem.count }.by(-1)
    end
  end
end
