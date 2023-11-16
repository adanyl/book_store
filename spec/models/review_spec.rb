# == Schema Information
#
# Table name: reviews
#
#  id         :bigint           not null, primary key
#  comment    :text
#  rating     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  book_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_reviews_on_book_id  (book_id)
#  index_reviews_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (book_id => books.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      review = build(:review)
      expect(review).to be_valid
    end

    it 'is not valid without a rating' do
      review = build(:review, rating: nil)
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include("can't be blank")
    end

    it 'is not valid with a rating less than 1' do
      review = build(:review, rating: 0)
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include('must be greater than or equal to 1')
    end

    it 'is not valid with a rating greater than 10' do
      review = build(:review, rating: 11)
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include('must be less than or equal to 10')
    end

    it 'is not valid without a book' do
      review = build(:review, book: nil)
      expect(review).not_to be_valid
      expect(review.errors[:book]).to include('must exist')
    end

    it 'is not valid without a user' do
      review = build(:review, user: nil)
      expect(review).not_to be_valid
      expect(review.errors[:user]).to include('must exist')
    end

    it 'is not valid with a duplicate book and user combination' do
      existing_review = create(:review)
      duplicate_review = build(:review, book: existing_review.book, user: existing_review.user)
      expect(duplicate_review).not_to be_valid
      expect(duplicate_review.errors[:book_id]).to include('has already been taken')
    end
  end

  describe 'Associations' do
    it 'belongs to a book' do
      association = described_class.reflect_on_association(:book)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end
  end
end
