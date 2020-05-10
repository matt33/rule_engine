module Products
    class Data
      ALL_PRODUCTS =
        {
          FR1: {name: 'Fruit tea', price: 3.11},
          AP1: {name: 'Apple', price: 5.00},
          CF1: {name: 'Coffee', price: 11.23}
        }

    def self.price_for_product(product_code, count = 1)
      if product_exists?(product_code)
        return ALL_PRODUCTS[product_code][:price] * count
      end
      0.0
    end

    def self.product_exists?(product_code)
      ALL_PRODUCTS[product_code]
    end
  end
end
