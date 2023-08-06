require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :percentage }
    it { should validate_presence_of :quantity }
    it { should validate_numericality_of(:percentage).is_greater_than(0) }
    it { should validate_numericality_of(:percentage).is_less_than(1.0) }
  end
  describe "relationships" do
    it { belong_to :merchant }
    it { belong_to(:invoice_item).optional}
  end

  describe "instance methods" do
    before :each do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @merchant2 = Merchant.create!(name: 'Jewelry')
      
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
      @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 10, merchant_id: @merchant1.id)
      @item_3 = Item.create!(name: "Brush", description: "This brushes your hair", unit_price: 15, merchant_id: @merchant1.id)

      @bulk_discount1 = BulkDiscount.create!(name: "10% off 10 items", percentage: 0.1, quantity: 10, merchant_id: @merchant1.id)
      @bulk_discount2 = BulkDiscount.create!(name: "20% off 15 items", percentage: 0.2, quantity: 15, merchant_id: @merchant1.id)
    end

    it "can convert a decimal to a percent" do
      expect(@bulk_discount1.decimal_to_percentage).to eq("10%")
      expect(@bulk_discount2.decimal_to_percentage).to eq("20%")
    end
  end
end
