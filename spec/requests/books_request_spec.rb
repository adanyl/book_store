require 'rails_helper'

RSpec.describe 'Books', type: :request do
  describe 'GET /books' do
    it 'renders the index template' do
      get books_path
      expect(response).to render_template(:index)
    end

    it 'returns a successful response' do
      get books_path
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @books with all books' do
      book1 = create(:book)
      book2 = create(:book)

      get books_path
      expect(assigns(:books)).to match_array([book1, book2])
    end
  end

  describe 'GET /books/:id' do
    it 'renders the show template' do
      book = create(:book)
      get book_path(book)
      expect(response).to render_template(:show)
    end

    it 'returns a successful response' do
      book = create(:book)
      get book_path(book)
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @book, @published_year, @genre, and @reviews' do
      book = create(:book, published_year: 2021, genre: 'Science Fiction')
      user1 = create(:user)
      user2 = create(:user)

      review1 = create(:review, user: user1, book: book)
      review2 = create(:review, user: user2, book: book)

      get book_path(book)

      expect(assigns(:book)).to eq(book)
      expect(assigns(:published_year)).to eq(2021)
      expect(assigns(:genre)).to eq('Science Fiction')
      expect(assigns(:reviews)).to match_array([review1, review2])
    end
  end
end
