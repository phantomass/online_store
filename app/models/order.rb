class Order < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  PAYMENT_TYPES = [ "Наличными", "PayPal" ]
  validates :address,presence: true
  validates :name, presence: true, length: { maximum: 20 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :pay_type, inclusion: PAYMENT_TYPES

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end

  def paypal_url(return_url)
    values = {
        :business => 'ilnurgilfanov7@gmail.com',
        :cmd => '_cart',
        :upload => 1,
        :return => return_url,
        :invoice => id,
        :currency_code => 'RUB'
    }
    line_items.each_with_index do |item, index|
      values.merge!({
                        "amount_#{index+1}" => item.product.price,
                        "item_name_#{index+1}" => item.product.title,
                        "item_number_#{index+1}" => item.product_id,
                        "quantity_#{index+1}" => item.quantity
                    })
    end
    "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
  end

end
