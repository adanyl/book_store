class OrdersController < ApplicationController
	before_action :authenticate_user!

	def index
		@orders = current_user.orders.not_draft.order(updated_at: :desc)
	end

	def show
		@order = current_user.orders.not_draft.find_by(id: params[:id])
	end

	def update
		order = current_user.orders.find_by(id: params[:id])

		if order.update(status: :pending)
      redirect_to orders_path, notice: 'Order was successfully confirmed.'
		else
			redirect_to show_draft_order_path, alert: 'Order not confirmed.'
		end
	end
end
  