require 'minitest/autorun'
require './lib/offer'

class TestOffer < Minitest::Test

    def test_x_for_price_of_y_with_2_for_1_apples_include
        items = ["apple", "apple"]
        assert_equal(-60, Offer.x_for_price_of_y(items, 2, 1, "apple"))
    end

    def test_x_for_price_of_y_with_2_for_1_apples_exclude
        items = ["apple"]
        assert_equal(0, Offer.x_for_price_of_y(items, 2, 1, "apple"))
    end

    def test_x_for_price_of_y_with_2_for_1_bananas_include
        items = ["banana", "banana"]
        assert_equal(-20, Offer.x_for_price_of_y(items, 2, 1, "banana"))
    end

    def test_x_for_price_of_y_with_2_for_1_bananas_exclude
        items = ["banana"]
        assert_equal(0, Offer.x_for_price_of_y(items, 2, 1, "banana"))
    end

    def test_x_for_price_of_y_with_3_for_2_oranges_include
        items = ["orange", "orange", "orange"]
        assert_equal(-25, Offer.x_for_price_of_y(items, 3, 2, "orange"))
    end

    def test_x_for_price_of_y_with_3_for_2_oranges_exclude
        items = ["orange", "orange"]
        assert_equal(0, Offer.x_for_price_of_y(items, 3, 2, "orange"))
    end

end
