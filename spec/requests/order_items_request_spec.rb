require 'rails_helper'

RSpec.describe 'OrderItems', type: :request do
  let(:user) { create(:user) }
  let(:order_item) { create(:order_item) }

  before do
    post user_session_path, params: { user: { email: user.email, password: user.password } }
    follow_redirect!
  end

  describe 'DELETE /order_items/:id' do
    it 'destroys the order item and saves the associated order' do
      order_item = create(:order_item)
      order = order_item.order
      order.total_price = 50.0
      order.save!

      expect do
        delete order_item_path(order_item)
      end.to change(OrderItem, :count).by(-1)

      expect(order.reload.total_price).to eq(0.0)

      expect(response).to redirect_to(show_draft_order_path)
      expect(flash[:notice]).to be_present
    end
  end
end
