class BooksController < ApplicationController
	def index
		@books = Book.all
	end

	def show
		@book = Book.find(params[:id])
		@published_year = @book.published_year || 'N/A'
    @genre = @book.genre || 'N/A'
	end
end
  