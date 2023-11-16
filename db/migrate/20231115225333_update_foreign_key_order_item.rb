class UpdateForeignKeyOrderItem < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :order_items, :orders
    remove_foreign_key :order_items, :books

    add_foreign_key :order_items, :orders, on_delete: :cascade
    add_foreign_key :order_items, :books, on_delete: :cascade
  end
end
