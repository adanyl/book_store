class CheckoutController < ApplicationController
  before_action :authenticate_user!

  def create_order_item
    book = Book.find(params[:book_id])
    draft_order = current_user.draft_order || current_user.orders.create(status: :draft, total_price: 0)

    order_item = draft_order.order_items.find_by(book_id: params[:book_id])

    if order_item.present?
      update_order_item(order_item, book, params[:quantity].to_i)
    else
      create_new_order_item(draft_order, book, params[:quantity].to_i)
    end

    draft_order.save!
  end

  def show_draft_order
    @draft_order = current_user.draft_order
  end

  private

  def create_new_order_item(draft_order, book, quantity)
    new_order_item = draft_order.order_items.new(book: book, quantity: quantity,
                                                 item_price: item_price(book.price, quantity))
    if new_order_item.save
      redirect_to book_path(book), notice: 'Book added.'
    else
      redirect_to book_path(book), alert: 'Can not add the book'
    end
  end

  def update_order_item(order_item, book, quantity)
    new_quantity = order_item.quantity + quantity
    if order_item.update(quantity: new_quantity, item_price: item_price(book.price, new_quantity))
      redirect_to book_path(book), notice: 'Book added.'
    else
      redirect_to book_path(book), alert: 'Can not add the book'
    end
  end

  def item_price(book_price, quantity)
    item_price = book_price * quantity
  end
end
