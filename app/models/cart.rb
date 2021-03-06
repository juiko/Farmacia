class Cart < ApplicationRecord
  has_many :cart_items, dependent: :delete_all
  belongs_to :transactionn,
             required: false,
             class_name: 'Transaction',
             foreign_key: 'transaction_id'

  def empty?
    items.empty?
  end

  def add(product, n)
    @item =
      begin
        CartItem.find_by! cart: self, product: product
      rescue ActiveRecord::RecordNotFound
        CartItem.create! cart: self, product: product
      end

    @item.increase_quantity(n)
    @item
  end

  def items
    cart_items.order id: :desc
  end

  def total
    items
      .map { |item| item.product.net_price * item.quantity }
      .inject(0, :+)
  end

  def drop
    items.each(&:drop)
  end
end
