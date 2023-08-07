require "rails_helper"

RSpec.describe "bulk discount index" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Jewelry Jar")
    @bulk_discount_1 = BulkDiscount.create!(name: "Fire Sale", percentage: 0.1, quantity: 10, merchant_id: @merchant1.id)
    @bulk_discount_2 = BulkDiscount.create!(name: "Going Out of Business", percentage: 0.25, quantity: 20, merchant_id: @merchant1.id)
    @bulk_discount_3 = BulkDiscount.create!(name: "Spring Fling", percentage: 0.30, quantity: 100, merchant_id: @merchant2.id)
  end

  it "has a link to a new bulk discount page" do
    visit merchant_bulk_discounts_path(@merchant1)
          
    click_link 'Create New Discount'
    
    expect(page).to have_content('New Bulk Discount')
  end

  it "has a list of all bulk discounts" do
    visit merchant_bulk_discounts_path(@merchant1)

    @merchant1.bulk_discounts.each do |bulk_discount|
      within("#bulk-discount-item-#{bulk_discount.id}") do
        expect(page).to have_content(bulk_discount.name)
        expect(page).to have_content("Percentage: #{(bulk_discount.percentage * 100).to_i}%")
        expect(page).to have_content("Quantity: #{bulk_discount.quantity}")
      end
    end
        expect(page).not_to have_content(@bulk_discount_3.name)
  end

  it "can delete a bulk discount" do
    visit merchant_bulk_discounts_path(@merchant1)
      
    click_link "Delete", match: :first
    
    expect(page).to have_current_path(merchant_bulk_discounts_path(@merchant1))
    expect(page).not_to have_content(@bulk_discount_1.name)
    expect(page).to have_content(@bulk_discount_2.name)
  end
end
