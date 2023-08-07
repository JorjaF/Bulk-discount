class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def discount
    item.best_discount(quantity)
  end

  def discounted_revenue 
    # I chose to calculate the disount fresh everytime instead of setting up a relationship on the invoice_item.
    # I think this is more efficient because it only calculates the discount when it is needed.
    # If I set up the relationship, new discounts won't apply to old "in-process"invoices.
    # but I could see how that might be useful too, i would just need more info.
    unit_price * quantity * (1 - discount.percentage)
  end
end
