require_relative 'list.rb'

module PricingRules
  # checks if rule is applicable for a given product and its count
  class ApplicableChecker
    def initialize(rule_code, product_code, count)
      @rule_code = rule_code
      @product_code = product_code
      @count = count
    end

    def applicable?
      for_product? && enough_items?
    end

    private

    attr_reader :rule_code, :product_code, :count

    def rule
      @rule ||= all_rules[rule_code]
    end

    def for_product?
      rule[:product_code] == product_code
    end

    def enough_items?
      count >= rule[:amount_needed]
    end

    def all_rules
      @all_rules ||=
        List::PRICING_RULES
    end
  end
end
