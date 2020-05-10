require_relative '../../lib/pricing_rules/applicable_checker.rb'

describe PricingRules::ApplicableChecker do
  let(:pricing_rules) do
    {
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

  subject(:checker) { described_class }

  before do
    allow_any_instance_of(PricingRules::ApplicableChecker)
      .to receive(:all_rules).and_return(pricing_rules)
  end

  context 'checks applicability of rules' do
    it 'is not applicable for low amount' do
      expect(checker
        .new('buy-one-get-one-free-fr1', :FR1, 1)
        .applicable?)
      .to be_falsey
      expect(checker
        .new('three-or-more-AP1', :AP1, 2)
        .applicable?)
      .to be_falsey
    end

    it 'is not applicable for other product code' do
      expect(checker
        .new('buy-one-get-one-free-fr1', :HT9, 19)
        .applicable?)
      .to be_falsey
    end

    it 'is applicable for appropriate amount' do
      expect(checker
        .new('buy-one-get-one-free-fr1', :FR1, 12)
        .applicable?)
      .to be_truthy
      expect(checker
        .new('three-or-more-AP1', :AP1, 3)
        .applicable?)
      .to be_truthy
    end
  end

end
