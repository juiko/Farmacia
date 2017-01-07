class AddQuantityToCartItem < ActiveRecord::Migration[5.0]
  def change
    add_column :cart_items, :quantity, :integer, default: 0
  end
end
