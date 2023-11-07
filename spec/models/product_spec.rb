require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do
    it 'is valid with all attributes present' do
      category = Category.new(name: 'Example Category')
      product = Product.new(
        name: 'Example Product',
        price: 10.99,
        quantity: 5,
        category: category
      )
      expect(product).to be_valid
    end

    it 'is not valid without a name' do
      category = Category.new(name: 'Example Category')
      product = Product.new(
        price: 10.99,
        quantity: 5,
        category: category
      )
      product.save
      expect(product.errors.full_messages).to include("Name can't be blank")
    end

    it 'is not valid without a price' do
      category = Category.new(name: 'Example Category')
      product = Product.new(
        name: 'Example Product',
        quantity: 5,
        category: category
      )
      product.save
      expect(product.errors.full_messages).to include("Price can't be blank")
    end

    it 'is not valid without a quantity' do
      category = Category.new(name: 'Example Category')
      product = Product.new(
        name: 'Example Product',
        price: 10.99,
        category: category
      )
      product.save
      expect(product.errors.full_messages).to include("Quantity can't be blank")
    end

    it 'is not valid without a category' do
      product = Product.new(
        name: 'Example Product',
        price: 10.99,
        quantity: 5
      )
      product.save
      expect(product.errors.full_messages).to include("Category can't be blank")
    end
  end
end

