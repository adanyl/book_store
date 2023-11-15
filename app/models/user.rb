class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reviews, dependent: :destroy
  has_many :orders, dependent: :destroy

  validate :single_draft_order, on: :create
  
  def draft_order
    orders.draft.first
  end

  private

  def single_draft_order
    if orders.draft.exists?
      errors.add(:base, 'Only one draft order is allowed per user.')
    end
  end
end
