require "rails_helper"

RSpec.describe "bulk discount show", type: :feature do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Jewelry Jar")
    @bulk_discount_1 = BulkDiscount.create!(name: "Fire Sale", percentage: 0.1, quantity: 10, merchant_id: @merchant1.id)
    @bulk_discount_2 = BulkDiscount.create!(name: "Going Out of Business", percentage: 0.25, quantity: 20, merchant_id: @merchant1.id)
    @bulk_discount_3 = BulkDiscount.create!(name: "Spring Fling", percentage: 0.30, quantity: 100, merchant_id: @merchant2.id)
  end

  it "can show specific merchants discounts" do
    visit merchant_bulk_discount_path(@merchant1, @bulk_discount_1)

    expect(page).to have_content(@bulk_discount_1.name)
    expect(page).to have_content(@bulk_discount_1.decimal_to_percentage)
    expect(page).to have_content(@bulk_discount_1.quantity)
  end

  it "can edit a bulk discount" do
    visit merchant_bulk_discount_path(@merchant1, @bulk_discount_1)
    expect(page).to have_link("Edit Discount")

    click_link "Edit Discount"

    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @bulk_discount_1))
  end
end
