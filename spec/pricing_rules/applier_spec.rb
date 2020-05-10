require_relative '../../lib/pricing_rules/applicable_checker.rb'

describe PricingRules::Applier do
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

  subject(:applier) { described_class }

  before do
    allow_any_instance_of(PricingRules::Applier)
      .to receive(:all_rules).and_return(pricing_rules)
  end

  context 'applies rules for different amount of items' do
    it 'calculates the right amount for FR1' do
      expect(applier
        .new('buy-one-get-one-free-fr1', :FR1, 1, 10).apply
      ).to be_falsey
      expect(applier
        .new('buy-one-get-one-free-fr1', :FR1, 11, 10).apply
      ).to eq(60)
      expect(applier
        .new('buy-one-get-one-free-fr1', :FR1, 2, 10).apply
      ).to eq(10)
    end

    it 'calculates the right amount for AP1' do
      expect(applier
        .new('three-or-more-AP1', :AP1, 2, 15).apply
      ).to be_falsey
      expect(applier
        .new('three-or-more-AP1', :AP1, 10, 15).apply
      ).to eq(45)
    end
  end

end
