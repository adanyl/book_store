require 'rails_helper'

RSpec.describe 'Home', type: :request do
  describe 'GET #index' do
    context 'when user is present' do
      let!(:user) { create(:user) }
      let!(:book) { create(:book) }
      let!(:order) { create(:order, user: user, status: :pending) }
      let!(:order_item) { create(:order_item, book: book, order: order) }

      before do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
        follow_redirect!
      end

      it 'assigns @books' do
        expect(assigns(:books)).to be_present
      end

      it 'returns the correct data in the response' do
        expect(response.body).to include(book.title)
      end

      it 'renders the index template' do
        expect(response).to render_template('index')
      end
    end

    context 'when user is not present' do
      before { get root_path }

      it 'does not assign @books' do
        expect(assigns(:books)).to be_nil
      end

      it 'renders the index template' do
        expect(response).to render_template('index')
      end
    end
  end
end
