require_relative 'products/data.rb'
require_relative 'pricing_rules/applicable_checker.rb'
require_relative 'pricing_rules/applier.rb'

# main class for checkout of items
# is initialized with pricing rules that will be applied once total
# price needs to be computed
class Checkout
  def initialize(pricing_rules)
    @pricing_rules = pricing_rules
    @items = {}
  end

  def scan(item_code)
    add_item(item_code)
  end

  def total
    calculate_total.to_f
  end

  private

  attr_reader :pricing_rules, :items

  def add_item(item_code)
    items[item_code.to_sym] = 0 unless items[item_code.to_sym]
    items[item_code.to_sym] += 1
  end

  def calculate_total
    items.keys.map do |product|
      subtotal_for_product(product)
    end.reduce(:+)
  end

  def subtotal_for_product(product)
    pricing_rules.each do |pricing_rule_code|
      if is_rule_applicable?(pricing_rule_code, product)
        return apply_rule(pricing_rule_code, product)
      end
    end
    full_product_price(product, items[product])
  end

  def is_rule_applicable?(pricing_rule_code, product)
    pricing_rule_applicable_checker
    .new(pricing_rule_code, product, items[product].to_i)
    .applicable?
  end

  def full_product_price(product, count = 1)
    Products::Data.price_for_product(product, count)
  end

  def apply_rule(pricing_rule, product_code)
    rule_applier
    .new(
      pricing_rule,
      product_code,
      items[product_code],
      full_product_price(product_code)
    ).apply
  end

  def pricing_rule_applicable_checker
    @pricing_rule_applicable_checker ||= PricingRules::ApplicableChecker
  end

  def rule_applier
    @rule_applier ||= PricingRules::Applier
  end
end
