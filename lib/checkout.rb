#!/usr/bin/env ruby

# Demo Ruby shopping cart exercise.
#
# Contact: Joel Parker Henderson <joel@joelparkerhenderson.com>
# License: BSD or MIT or GPL

require './lib/cart'
require './lib/offer'
require './lib/shop'
require './lib/till'

# The command line program. 
#
# Syntax:
#
# ```sh
# checkout.rb [item] ...
# ```
#
# Example:
#
# ```sh
# $ ./lib/checkout apple banana orange
# The total cost is 85 cents aka 0.85 dollars
# ```
#
# Input: item names as strings.
#
# Output: the total cost including discounts.
#
# For a production program, we would refactor the command to its own executable,
# would call a library that contains the business logic and data access.
#
if __FILE__ == $0
    cart = Cart.new
    cart.add_items(*ARGV)
    cost = Till.total_cost(cart.items) 
    print "Total cost is #{cost} cents aka #{cost.to_f/100} dollars\n"
end
