require 'minitest/autorun'
require './lib/shop'

class TestShop < Minitest::Test

    def test_item_cost_with_apple
        item = "apple"
        assert_equal 60, Shop.item_cost(item)
    end
    
    def test_item_cost_with_banana
        item = "banana"
        assert_equal 20, Shop.item_cost(item)
    end
    
    def test_item_cost_with_orange
        item = "orange"
        assert_equal 25, Shop.item_cost(item)
    end

end
