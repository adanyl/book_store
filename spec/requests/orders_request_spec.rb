require 'rails_helper'

RSpec.describe 'Orders', type: :request do
  let(:user) { create(:user) }

  before do
    post user_session_path, params: { user: { email: user.email, password: user.password } }
    follow_redirect!
  end

  describe 'GET /orders' do
    it 'renders the index template' do
      get orders_path
      expect(response).to render_template(:index)
    end
  end

  describe 'GET /orders/:id' do
    it 'renders the show template' do
      order = create(:order, user: user)
      get order_path(order)
      expect(response).to render_template(:show)
    end
  end

  describe 'PATCH /orders/:id' do
    context 'with valid parameters' do
      it 'updates the order status to pending' do
        order = create(:order, user: user, status: :draft)

        patch order_path(order)

        expect(order.reload.status).to eq('pending')
        expect(response).to redirect_to(orders_path)
        expect(flash[:notice]).to be_present
      end
    end
  end
end
