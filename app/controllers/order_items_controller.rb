class OrderItemsController < ApplicationController
	before_action :authenticate_user!

	def destroy
		order_item = OrderItem.find(params[:id])
		order_item.destroy

		redirect_to show_draft_order_path, notice: 'Order Item was successfully deleted.'
	end
end