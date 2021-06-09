# The Offer class provides discounts such as "3 for the price of 2 on oranges."
#
# The implementation is more-akin to a functional service, and less-akin to
# object oriented programming. Notably `items` is always the first param.
#
# In a production program, we would refactor to use a separate Cart structure.
# In this demo program, we use an items array because it's so simple.
#
class Offer

    # Calculate a discount offer that is of the general form "X for price of Y".
    # For example "Buy One Get One" (BOGO) is equivalent to "2 for price of 1".
    #
    # This method returns the cost adjustment, which is always zero or negative,
    # in order to work well with subtotal processes.
    #
    # Example:
    # ```
    # items = ["apple", "apple"]
    # cost = Offer.x_for_price_of_y(items, 2, 1, "apple")
    # #=> -60
    # ```
    #
    def self.x_for_price_of_y(items, x, y, item)
        (items.count(item) / x) * (x - y) * -Shop.item_cost(item)
    end

end
