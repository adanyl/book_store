class ReviewsController < ApplicationController
    before_action :authenticate_user!, except: :show
  
    def show
      @review = Review.find(params[:id])
    end
  
    def destroy
      review = Review.find(params[:id])
      book = review.book
      review.destroy
  
      redirect_to book_path(book), notice: 'Review was successfully deleted.'
    end
  end