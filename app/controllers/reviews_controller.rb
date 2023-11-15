class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: :show

  def show
    @review = Review.find(params[:id])
    @book = @review.book
  end

  def new
    @book = Book.find(params[:book_id])
  end

  def create
    review = Review.new(review_params)
    review.user = current_user

    if review.save
      redirect_to review_path(review), notice: 'Review was successfully created.'
    else
      redirect_to new_review_path(book_id: params[:book_id]), alert: 'Review can not be created'
    end
  end

  def edit
    @review = Review.find(params[:id])
  end

  def update
    review = Review.find(params[:id])

    if review.update(review_params)
      redirect_to review_path(review), notice: 'Review was successfully updated.'
    else
      redirect_to edit_review_path(review), alert: 'Review can not be updated'
    end
  end

  def destroy
    review = Review.find(params[:id])
    book = review.book
    review.destroy

    redirect_to book_path(book), notice: 'Review was successfully deleted.'
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment, :book_id)
  end
end
