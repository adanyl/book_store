class HomeController < ApplicationController
  def index
    return unless current_user.present?

    @books = Book.bought_by_user(current_user.id)
  end
end
