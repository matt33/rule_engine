require_relative 'list.rb'
require 'pry'

module PricingRules
  # applies pricing rule on an item in basket and returns price
  # for count of all items of given product in basket
  class Applier
    def initialize(rule_code, product_code, count, price_for_product)
      @rule_code = rule_code
      @product_code = product_code
      @count = count
      @price_for_product = price_for_product
    end

    def apply
      return false unless ApplicableChecker
        .new(rule_code, product_code, count).applicable?
      discounted_count * discounted_price +
      original_price_count * price_for_product
    end

    private

    attr_reader :rule_code, :product_code, :count, :price_for_product

    def rule
      @rule ||= all_rules[rule_code]
    end

    def discounted_count
      @discounted_count ||=
        count / rule[:apply_discount_to_every]
    end

    def original_price_count
      @original_price_count ||=
        count - discounted_count
    end

    def discounted_price
      @discounted_price ||=
        rule[:discounted_price].to_f || (rule[:discount_percent].to_f * price_for_product)
    end

    def all_rules
      @all_rules ||=
        List::PRICING_RULES
    end
  end
end
