# The Shop class manages the state of the shop. Currently the state has the
# items and costs.
#
# The cost unit is British cents which is 0.01 of the British pound. 
#
# Money units tend to be better to implement as the smallest-necessary unit
# rather than as a decimal floating point number. I.e. we implement using cents
# and integer math, not pound and floating point math.
#
# The implementation is more-akin to a functional service, and less-akin to
# object oriented programming.
#
class Shop

    # The DATA structure implementation is general purpose, because it's easy to
    # read, easy to edit, and easy to extend. In a real program, the data would
    # likely be managed by a database such as Postgres, and would likely have more
    # capabilties such as for updates.
    #
    DATA = {
        items: {
            apple: { 
                cost: 60
            },
            banana: { 
                cost: 20 
            },
            orange: { 
                cost: 25
            },
        }
    }

    # Get the item cost.
    # 
    # Example:
    # ```
    # cost = Shop.item_cost("apple")
    # #=> 60
    # ```
    #
    def self.item_cost(item)
        DATA[:items][item.to_sym][:cost]
    end

end
