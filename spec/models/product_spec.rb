require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do
    # validation tests/examples here
    it 'saves properly with all 4 fields' do
      @category = Category.new(name: "Bob")
      @product = Product.new(name: "Bob Machine", price: 100, quantity: 1, category: @category)
      expect {
        @product.save
      }.to change(Product, :count).by(1)
      expect(@product.errors.full_messages).to be_empty
    end
    it 'validates name' do
      @category = Category.new(name: "Bob")
      @product = Product.new(price: 100, quantity: 1, category: @category)
      @product.save
      expect(@product.errors.full_messages).to include("Name can't be blank")
    end
    it 'validates price' do
      @category = Category.new(name: "Bob")
      @product = Product.new(name: "Bob Machine", quantity: 1, category: @category)
      @product.save
      expect(@product.errors.full_messages).to include("Price can't be blank")
    end
    it 'validates quantity' do
      @category = Category.new(name: "Bob")
      @product = Product.new(name: "Bob Machine", price: 100, category: @category)
      @product.save
      expect(@product.errors.full_messages).to include("Quantity can't be blank")
    end
    it 'validates category' do
      @category = Category.new(name: "Bob")
      @product = Product.new(name: "Bob Machine", price: 100, quantity: 1)
      @product.save
      expect(@product.errors.full_messages).to include("Category can't be blank")
    end
  end
end