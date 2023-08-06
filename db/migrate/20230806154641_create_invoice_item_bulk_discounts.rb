class CreateInvoiceItemBulkDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :invoice_item_bulk_discounts do |t|
      t.references :invoice_item, null: false, foreign_key: true
      t.references :bulk_discount, null: false, foreign_key: true

      t.timestamps
    end
  end
end
