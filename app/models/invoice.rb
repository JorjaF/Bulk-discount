class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_revenue_with_discount
    invoice_items.sum do |invoice_item|
      invoice_item.discount.nil? ? invoice_item.unit_price * invoice_item.quantity : invoice_item.discounted_revenue
    end
  end

  def formatted_total_revenue_with_discount
    "$#{total_revenue_with_discount.round(2)}"
  end
end
