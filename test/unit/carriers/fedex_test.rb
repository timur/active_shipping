require 'test_helper'

class FedExTest < Test::Unit::TestCase
  def setup
    @carrier                = FedEx.new(:key => '1111', :password => '2222', :account => '3333', :login => '4444')
  end
  
  def test_initialize_options_requirements
    assert_raises ArgumentError do FedEx.new end
    assert_raises ArgumentError do FedEx.new(:login => '999999999') end
    assert_raises ArgumentError do FedEx.new(:password => '7777777') end
    assert_nothing_raised { FedEx.new(:key => '999999999', :password => '7777777', :account => '123', :login => '123')}
  end

  def test_business_days
    today = DateTime.civil(2013, 3, 12, 0, 0, 0, "-4")

    Timecop.freeze(today) do
      assert_equal DateTime.civil(2013, 3, 13, 0, 0, 0, "-4"), @carrier.send(:business_days_from, today, 1)
      assert_equal DateTime.civil(2013, 3, 15, 0, 0, 0, "-4"), @carrier.send(:business_days_from, today, 3)
      assert_equal DateTime.civil(2013, 3, 19, 0, 0, 0, "-4"), @carrier.send(:business_days_from, today, 5)
    end
  end

end
