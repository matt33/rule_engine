module PricingRules
  class List

    PRICING_RULES = {
      'buy-one-get-one-free-fr1' => {
        product_code: :FR1,
        amount_needed: 2,
        discount_percent: 100,
        apply_discount_to_every: 2
      },
      'three-or-more-AP1' => {
        product_code: :AP1,
        amount_needed: 3,
        discounted_price: 4.50,
        apply_discount_to_every: 1
      }
    }
  end
end
