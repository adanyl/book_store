require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'is not valid without an email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it 'is not valid without an email' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
    end
  end

  describe 'Associations' do
    it 'has many reviews' do
      association = described_class.reflect_on_association(:reviews)
      expect(association.macro).to eq :has_many
    end

    it 'has many orders' do
      association = described_class.reflect_on_association(:orders)
      expect(association.macro).to eq :has_many
    end

    it 'destroys dependent reviews' do
      user = create(:user)
      review = create(:review, user: user)

      expect { user.destroy }.to change { Review.count }.by(-1)
    end

    it 'destroys dependent orders' do
      user = create(:user)
      order = create(:order, user: user)

      expect { user.destroy }.to change { Order.count }.by(-1)
    end
  end

  describe '#draft_order' do
    it 'returns the draft order if present' do
      user = create(:user)
      draft_order = create(:order, user: user, status: 'draft')

      expect(user.draft_order).to eq(draft_order)
    end

    it 'returns nil if no draft order' do
      user = create(:user)

      expect(user.draft_order).to be_nil
    end
  end
end
