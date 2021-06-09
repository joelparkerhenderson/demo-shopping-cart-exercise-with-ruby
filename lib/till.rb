# The Till class manages the checkout process, including calculating the total
# cost of all the shopper's items, and providing potential discounts.
#
# The implementation is more-akin to a functional service, and less-akin to
# object oriented programming. Notably `items` is always the first param.
#
# In a production program, we would refactor to use a separate Cart structure.
# In this demo program, we use an items array because it's so simple.
#
class Till

    # Calculate the total cost of the given items, including discounts.
    #
    # Example:
    # ```
    # items = ["apple", "orange"]
    # cost = Till.total_cost(items)
    # #=> 85
    # ```
    #
    def self.total_cost(items)
        _free_item, *paid_items = self.sort_by_cost(items)
        self.subtotal_cost(paid_items) +
        Offer.x_for_price_of_y(paid_items, 2, 1, "apple") +
        Offer.x_for_price_of_y(paid_items, 2, 1, "banana") +
        Offer.x_for_price_of_y(paid_items, 3, 2, "orange")
    end

    # Calculate the total cost of the given items, without any discounts.
    #
    # Example:
    # ```
    # items = ["apple", "orange"]
    # cost = Till.subtotal_cost(items)
    # #=> 85
    # ```
    #
    def self.subtotal_cost(items)
        items.map{|item| Shop.item_cost(item)}.sum
    end

    # Sort items by cost.
    #
    # Example:
    # ```
    # items = ["apple", "banana", "orange"]
    # sorted = Till.sort_items_by_cost(items)
    # #=> ["banana", "orange", "apple"]
    # ````
    #
    def self.sort_by_cost(items)
        items.sort_by{|item| Shop.item_cost(item)}
    end

end
