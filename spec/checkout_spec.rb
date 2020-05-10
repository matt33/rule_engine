require_relative '../lib/checkout.rb'

describe Checkout do
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
  let(:product_code_1) { :FR1 }
  let(:product_code_2) { :AP1 }
  let(:product_code_3) { :CF1 }
  let(:product_1_price) { Products::Data.price_for_product(product_code_1) }
  let(:product_2_price) { Products::Data.price_for_product(product_code_2) }
  let(:product_3_price) { Products::Data.price_for_product(product_code_3) }

  context 'only buy-one-get-one-free-fr1 is applied' do
    before do
      @checkout = described_class.new(['buy-one-get-one-free-fr1'])
    end

    it 'applies discount correctly for 2 same items' do
      @checkout.scan(product_code_1)
      @checkout.scan(product_code_1)
      expect(@checkout.total).to eq(product_1_price)
    end

    it 'applies discount correctly for 5 same items FR1 and 2 AP1' do
      5.times { @checkout.scan(product_code_1) }
      2.times { @checkout.scan(product_code_2) }
      expect(@checkout.total).to eq(
        3 * product_1_price + 2 * product_2_price
      )
    end

    it 'applies discount correctly for 10 same items FR1, 7 AP1, 3 CF1' do
      10.times { @checkout.scan(product_code_1) }
      7.times { @checkout.scan(product_code_2) }
      3.times { @checkout.scan(product_code_3) }
      expect(@checkout.total).to eq(
        5 * product_1_price + 7 * product_2_price + 3 * product_3_price
      )
    end

    it 'does not apply discount - not enough items' do
       @checkout.scan(product_code_1)
       expect(@checkout.total).to eq(product_1_price)
    end

  end

  context 'only three-or-more-AP1 is applied' do
    before do
      @checkout = described_class
        .new(['three-or-more-AP1'])
    end

    it 'applies discount correctly for 7 same items' do
      7.times { @checkout.scan(product_code_2) }
      expect(@checkout.total).to eq(7 * 4.50)
    end

    it 'applies discount correctly for items of multiple types' do
      4.times { @checkout.scan(product_code_1) }
      9.times { @checkout.scan(product_code_2) }
      2.times { @checkout.scan(product_code_3) }
      expect(@checkout.total).to eq(
        4 * product_1_price + 9 * 4.50 + 2 * product_3_price
      )
    end
  end

  context 'applies both rules' do
    before do
      @checkout = described_class
        .new(['buy-one-get-one-free-fr1', 'three-or-more-AP1'])
    end

    it 'applies discount correctly for 7 same items' do
      7.times { @checkout.scan(product_code_2) }
      expect(@checkout.total).to eq(7 * 4.50)
    end

    it 'applies discount correctly for items of multiple types' do
      4.times { @checkout.scan(product_code_1) }
      9.times { @checkout.scan(product_code_2) }
      2.times { @checkout.scan(product_code_3) }
      expect(@checkout.total).to eq(
        2 * product_1_price + 9 * 4.50 + 2 * product_3_price
      )
    end

    it 'applies discount correctly for edge cases' do
      2.times { @checkout.scan(product_code_1) }
      3.times { @checkout.scan(product_code_2) }
      expect(@checkout.total).to eq(
        1 * product_1_price + 3 * 4.50
      )
    end
  end


end
