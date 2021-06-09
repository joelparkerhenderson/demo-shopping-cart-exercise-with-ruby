require 'minitest/autorun'
require './lib/till'

class TestTill < Minitest::Test

    def test_subtotal_cost_with_example_list
        items = ["apple", "apple", "orange", "apple"]
        assert_equal(205, Till.subtotal_cost(items))
    end

    def test_total_cost_with_cheapest_item_free
        items = ["apple", "banana", "orange"]
        assert_equal(85, Till.total_cost(items))
    end

    def test_total_cost_with_cheap_item_and_2_for_1_apples_include_and_2_for_1_bananas_include_and_3_for_2_oranges_include
        items = ["banana", "apple", "apple", "banana", "banana", "orange", "orange", "orange"]
        assert_equal(130, Till.total_cost(items))
    end

    def test_total_cost_with_cheap_item_and_2_for_1_apples_exclude_and_2_for_1_bananas_exclude_and_3_for_2_oranges_exclude
        items = ["banana", "apple", "banana", "orange", "orange"]
        assert_equal(130, Till.total_cost(items))
    end
    
    def test_sort_by_cost
        items = ["apple", "banana", "orange"]
        assert_equal(["banana", "orange", "apple"], Till.sort_by_cost(items))
    end

end
