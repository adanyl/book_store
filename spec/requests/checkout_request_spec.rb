require 'rails_helper'

RSpec.describe 'Checkout', type: :request do
  let(:user) { create(:user) }
  let(:book) { create(:book) }

  before do
    post user_session_path, params: { user: { email: user.email, password: user.password } }
    follow_redirect!
  end

  describe 'POST /create_order_item' do
    context 'when adding a new book to the draft order' do
      it 'creates a new order item and redirects to the book path' do
        expect do
          post create_order_item_path(book_id: book.id, quantity: 2)
        end.to change(OrderItem, :count).by(1)

        expect(response).to redirect_to(book_path(book))
        expect(flash[:notice]).to be_present
      end
    end

    context 'when updating an existing order item' do
      it 'updates the order item and redirects to the book path' do
        order = create(:order, user: user, status: :draft)
        order_item = create(:order_item, order: order, book: book, quantity: 1)

        expect do
          post create_order_item_path(book_id: book.id, quantity: 2)
        end.to_not change(OrderItem, :count)

        order_item.reload
        expect(order_item.quantity).to eq(3) # 1 existing + 2 new

        expect(response).to redirect_to(book_path(book))
        expect(flash[:notice]).to be_present
      end
    end
  end

  describe 'GET /show_draft_order' do
    it 'renders the show_draft_order template' do
      draft_order = create(:order, user: user, status: :draft)

      get show_draft_order_path

      expect(response).to render_template(:show_draft_order)
      expect(assigns(:draft_order)).to eq(draft_order)
    end
  end
end
