require 'minitest/autorun'
require './lib/checkout'

class TestCheckout < Minitest::Test

    def test_command
        assert_output("Total cost is 85 cents aka 0.85 dollars\n") {
            puts `./lib/checkout.rb apple banana orange`
        }
    end   

end
