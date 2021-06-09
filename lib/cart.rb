# The Cart class holds the user's items.
#
# The user's cart is intended to interact with the till,
# because the till will look at the items in the cart,
# and provide the total cost of the items in the cart.
# 
# This approach provides a deliberate separate of concerns,
# where the cart concern is managing the state i.e. items,
# and the till concern is managing the pricing process.
#
class Cart

    attr_accessor :items

    def initialize
        @items = []
    end

    def add_items(*items)
        @items.append(*items)
    end

end
