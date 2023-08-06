require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end
  describe "instance methods" do
    it "total_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.total_revenue).to eq(100)
    end

    it "can assign a discount to an invoice item" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 16, unit_price: 10, status: 1)
      @bulk_discount1 = BulkDiscount.create!(name: "10% off 10 items", percentage: 0.1, quantity: 10, merchant_id: @merchant1.id)
      @bulk_discount2 = BulkDiscount.create!(name: "20% off 15 items", percentage: 0.2, quantity: 15, merchant_id: @merchant1.id)

      expect(@invoice_1.invoice_items[0].discount).to eq(@bulk_discount1)
      expect(@invoice_1.invoice_items[1].discount).to eq(@bulk_discount2)
    end

    it "can find the total revenue with discounts" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 16, unit_price: 10, status: 1)
      @bulk_discount1 = BulkDiscount.create!(name: "10% off 10 items", percentage: 0.1, quantity: 10, merchant_id: @merchant1.id)
      @bulk_discount2 = BulkDiscount.create!(name: "20% off 15 items", percentage: 0.2, quantity: 15, merchant_id: @merchant1.id)

      expect(@invoice_1.total_revenue_with_discount).to eq(218)
      expect(@invoice_1.total_revenue_with_discount).to_not eq(@invoice_1.total_revenue)
    end

    it "can show, what if any, bulk discount is applied" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 16, unit_price: 10, status: 1)
      @bulk_discount1 = BulkDiscount.create!(name: "10% off 10 items", percentage: 0.1, quantity: 10, merchant_id: @merchant1.id)
      @bulk_discount2 = BulkDiscount.create!(name: "20% off 15 items", percentage: 0.2, quantity: 15, merchant_id: @merchant1.id)
      @bulk_discount3 = BulkDiscount.create!(name: "30% off 500 items", percentage: 0.3, quantity: 20, merchant_id: @merchant1.id)
      
      expect(@invoice_1.invoice_items[0].discount).to eq(@bulk_discount1)
      expect(@invoice_1.invoice_items[1].discount).to eq(@bulk_discount2)
      expect(@invoice_1.invoice_items[0].discount).to_not eq(@bulk_discount2)
      expect(@invoice_1.invoice_items[1].discount).to_not eq(@bulk_discount3)
    end

    it "can formatted_total_revenue_with_discount" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 16, unit_price: 10, status: 1)
      @bulk_discount1 = BulkDiscount.create!(name: "10% off 10 items", percentage: 0.1, quantity: 10, merchant_id: @merchant1.id)
      @bulk_discount2 = BulkDiscount.create!(name: "20% off 15 items", percentage: 0.2, quantity: 15, merchant_id: @merchant1.id)
      @bulk_discount3 = BulkDiscount.create!(name: "30% off 500 items", percentage: 0.3, quantity: 20, merchant_id: @merchant1.id)

      expect(@invoice_1.formatted_total_revenue_with_discount).to eq("$218.0")
    end
  end
end
