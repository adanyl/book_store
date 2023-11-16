require 'rails_helper'

RSpec.describe 'Reviews', type: :request do
  let(:user) { create(:user) }

  before do
    post user_session_path, params: { user: { email: user.email, password: user.password } }
    follow_redirect!
  end

  describe 'GET /reviews/:id' do
    it 'renders the show template' do
      review = create(:review)
      get review_path(review)
      expect(response).to render_template(:show)
    end

    it 'returns a successful response' do
      review = create(:review)
      get review_path(review)
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @review and @book' do
      review = create(:review)
      get review_path(review)
      expect(assigns(:review)).to eq(review)
      expect(assigns(:book)).to eq(review.book)
    end
  end

  describe 'GET /reviews/new' do
    it 'renders the new template' do
      book = create(:book)
      get new_review_path(book_id: book.id)
      expect(response).to render_template(:new)
    end

    it 'returns a successful response' do
      book = create(:book)
      get new_review_path(book_id: book.id)
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @book' do
      book = create(:book)
      get new_review_path(book_id: book.id)
      expect(assigns(:book)).to eq(book)
    end
  end

  describe 'POST /reviews' do
    context 'with valid parameters' do
      it 'creates a new review' do
        book = create(:book)
        valid_params = { review: attributes_for(:review, book_id: book.id) }

        expect do
          post reviews_path, params: valid_params
        end.to change(Review, :count).by(1)

        expect(response).to redirect_to(review_path(Review.last))
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new review' do
        book = create(:book)
        invalid_params = { review: attributes_for(:review, rating: nil, book_id: book.id) }

        expect do
          post reviews_path, params: invalid_params
        end.not_to change(Review, :count)

        expect(response).to redirect_to(new_review_path(book_id: book.id))
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'GET /reviews/:id/edit' do
    it 'renders the edit template' do
      review = create(:review)
      get edit_review_path(review)
      expect(response).to render_template(:edit)
    end

    it 'returns a successful response' do
      review = create(:review)
      get edit_review_path(review)
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @review' do
      review = create(:review)
      get edit_review_path(review)
      expect(assigns(:review)).to eq(review)
    end
  end

  describe 'PATCH /reviews/:id' do
    context 'with valid parameters' do
      it 'updates the review' do
        review = create(:review)
        valid_params = { review: attributes_for(:review) }

        patch review_path(review), params: valid_params
        review.reload

        expect(review.rating).to eq(valid_params[:review][:rating])
        expect(response).to redirect_to(review_path(review))
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid parameters' do
      it 'does not update the review' do
        review = create(:review)
        invalid_params = { review: attributes_for(:review, rating: nil) }

        patch review_path(review), params: invalid_params
        review.reload

        expect(review.rating).not_to be_nil
        expect(response).to redirect_to(edit_review_path(review))
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'DELETE /reviews/:id' do
    it 'destroys the review' do
      review = create(:review)

      expect do
        delete review_path(review)
      end.to change(Review, :count).by(-1)

      expect(response).to redirect_to(book_path(review.book))
      expect(flash[:notice]).to be_present
    end
  end
end
