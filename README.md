# Demo of shoppping cart exercise with Ruby

This is a programming exercise that creates a simple shopping cart program.

The concept:

* A shop sells apples, bananas, oranges.

* A cart holds a user's items.

* A till calculates the cost of a cart's items.

* An offer is a potential discount such as buy one get one free.

* A checkout program handles the input and output.

The domain driven design:

* `Shop` provides item names and costs. This is constant i.e. the exercise data never changes.

* `Cart` holds a user's items. This is a stateful i.e. the cart can be empty or contain a variety of items.

* `Till` calculates and is purely functional i.e. it sums a total cost based on cart items, shop costs, and offers.

* `Offer` calculates and is purely functional i.e. it evaluates each discount, if it applies, and for what amount.

* `Checkout` is a command line interface i.e. it inputs, creates a cart, sends items to the till, and outputs.

Implementation preferences:

* We favor separation of functional code from stateful code. For example we separate the `Till` concept (which is functional) and the `Cart` concept (which is stateful).

* We favor separation of domain concerns. For example we separate the `Till` concept (which focuses on the concern of tallying a total cost) and the `Offer` concept (which focuses on the concern of special-case discounts).

* We favor separation of files. For example we will create separate files `shop.rb`, `cart.rb`, `till.rb`, `offer.rb`, `checkout.rb`.

Testing preferences:

* We favor readable test names that have plenty of detail, rather than test names that aren't as obvious.

* We favor test driven development (TDD) which writes a test and runs the test to prove it fails, then implements the logic and runs the test to prove it succeeds.

* We favor Ruby Minitest test style with `assert()`, rather than Minitest spec style with `expect()`, because the test style tends to be faster to write, clearer to document, and more effective to refactor as needed.


## Exercise 1: Shopping cart

Build a shopping cart checkout system for a shop that sells apples and oranges.

* Apples cost 60 cents each.

* Oranges cost 25 cents each.

Build a checkout system which takes a cart of items scanned at the till and outputs the total cost.

* For example: [ apple, apple, orange, apple ] => 2.05 dollars


## Setup

Create a directory for the program then go into it:

```sh
mkdir demo && cd demo
mkdir lib
mkdir test
```

Create a typical file `Rakefile` that will run the tests:

```ruby
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

task :default => :test
```


## Requirement: the apples cost 60 cents

**Setup:** We want a shop that has item names and costs:

```sh
touch lib/shop.rb
touch test/test_shop.rb
```

**TDD:** Edit `test_shop.rb` and create a test for a new method `item_cost`:

```ruby
class TestShop < Minitest::Test

    def test_item_cost_with_apple
        item = "apple"
        assert_equal 60, Shop.item_cost(item)
    end

end
```

Run `rake` and it fails as planned.

**Implement:** Edit `shop.rb` and create a class `Shop` with the data of items and costs:

```ruby
class Shop

    DATA = {
        items: {
            apple: { 
                cost: 60
            },
        }
    }

    def self.item_cost(item)
        DATA[:items][item.to_sym][:cost]
    end

end
```

Run `rake` and it succeeds.

Notes:

* The cost unit is USD cents which is 0.01 of a USD dollar.

* Money units tend to be better to implement as the smallest-necessary unit rather than as a decimal floating point number. I.e. we implement using cents and integer math, not pound and floating point math.

* The method `Shop.item_cost` is a class method, rather than an instance method. The class method is more-akin to a functional approach, and less-akin to an object oriented programming (OOP).

* The DATA structure is general purpose. It's easy to read, easy to edit, and easy to extend. In a real program, the data would likely be managed by a database such as Postgres, and would likely have more capabilties such as for updates.


## Requirement: the oranges cost 25 cents

**TDD:** Add oranges

```ruby
class TestShop < Minitest::Test

    def test_item_cost_with_apple
        item = "apple"
        assert_equal 60, Shop.item_cost(item)
    end

    def test_item_cost_with_orange
        item = "orange"
        assert_equal 25, Shop.item_cost(item)
    end

end
```

Run `rake` and it fails as planned.

Immplementation: Add oranges:

```
class Shop

    DATA = {
        items: {
            …
            orange: { 
                cost: 25
            },
        }
    }
…
```

Run `rake` and it succeeds.


## Requirement: a cart

**Setup:** We want a cart that can hold items:

```sh
touch lib/cart.rb
touch test/test_cart.rb
```

**TDD:** Edit `test_cart.rb` and create a test for `initialize` that creates a cart that's empty:

```ruby
class TestCart < Minitest::Test

    def setup
        @cart = Cart.new
    end

    def test_initialize
        assert @cart.items.empty?
    end

end
```

Run `rake` and it fails as planned.

**Implement:** Edit `cart.rb` and create a class that has an array of items that starts empty:

```ruby
class Cart

    attr_accessor :items

    def initialize
        @items = []
    end

end
```

Run `rake` and it succeeds.

Notes:

* In a real program, we would likely have the `Cart` encapsulate the items array, such as with a getter and setter, rather than making the items array public as above-- which is simply to expedite this exercise.

* In a real program, we would like make the `Cart` validate added items, and also provide related methods for removing items, saving items for later purchases, and the like.


## Requirement: add items to the cart

**TDD:** Create a method `add_items` that takes items:

```ruby
class TestCart < Minitest::Test
    …
    def test_add_items
        assert_equal [], @cart.items
        @cart.add_items("apple", "orange")
        assert_equal ["apple", "orange"], @cart.items
    end
    …
```

Run `rake` and it fails as planned.

**Implement:** Add items and make it easy by using the Ruby splat operator to handle multiple items:

```ruby
class TestCart < Minitest::Test
    …
    def add_items(*items)
        @items.append(*items)
    end
    …
```

Run `rake` and it succeeds.


## Requirement: calculate the total cost

**Setup:** We want a till that can calculate the total cost of items:

```sh
touch lib/till.rb
touch test/test_till.rb
```

**TDD:** Edit `test_till.rb` and create a test for a new method `total_cost`:

```ruby
class TestTill < Minitest::Test
    …
    def test_total_cost_with_example_list
        items = ["apple", "apple", "orange", "apple"]
        assert_equal 205, Till.total_cost(items)
    end
    …
```

Run `rake` and it fails as planned.

**Implement:** Edit `till.rb` and create the method:

```ruby
class Till

    def self.total_cost(items)
        items.map{|item| Shop.item_cost(item)}.sum
    end

end
```

Run `rake` and it succeeds.

Notes:

* Much like the method `Shop.item_cost`, the method `Till.total_cost` is a class method, rather than as an instance method. The class method is more-akin to a functional approach, and less-akin to an object oriented programming (OOP).


## Requirement: Build a checkout system which takes a cart of items scanned at the till and outputs the total cost

**Setup**: We want a checkout capability that reads input, calculates using the shop costs and cart items, and writes output:

```sh
touch lib/checkout.rb
touch test/test_checkout.rb
```

**TDD:** Edit `test_checkout.rb` that runs a command that outputs "Total cost TODO":

```ruby
require 'minitest/autorun'
require './lib/checkout'

class TestCheckout < Minitest::Test
    def test_command
        assert_output("Total cost TODO\n") {
            puts `./lib/checkout.rb`
        }
    end   
end
```

Run `rake` and it fails as planned.

**Implement:** Create a file `./lib/checkout.rb` that runs the command:

```ruby
#!/usr/bin/env ruby
if __FILE__ == $0
    puts "Total cost TODO"
end
```

Set permissions to executable:

```sh
chmod +x checkout.rb
```

Run `rake` and it succeeds.

**TDD:** Refine the test to make it output the total cost

```ruby
class TestCheckout < Minitest::Test

    def test_command
        assert_output("Total cost is 85 cents\n") {
            puts `./lib/checkout.rb apple orange`
        }
    end   

end
```

Run `rake` and it fails as planned.

**Implement:** Refine the checkout to output the total cost:

```sh
require './lib/cart'
require './lib/till'
require './lib/shop'

if __FILE__ == $PROGRAM_NAME
    cart = Cart.new
    cart.add_items(ARGV)
    cost = Till.total_cost(cart.items) 
    print "Total cost is #{cost} cents\n"
end
```

Run `rake` and it succeeds.

**TDD:** Refine the test to output the total cost also as dollars:

```ruby
class TestCheckout < Minitest::Test

    def test_main
        assert_output("Total cost is 85 cents aka 0.85 dollars\n") {
            puts `./lib/checkout.rb apple orange`
        }
    end   

end
```

Run `rake` and it fails as planned.

**Implement:** Refine the logic to output:

```ruby
if __FILE__ == $PROGRAM_NAME
    cart = Cart.new
    cart.add_items(ARGV)
    cost = Till.total_cost(cart.items) 
    print "Total cost is #{cost} cents aka #{cost.to_f/100} dollars.\n"
end
```

Run `rake` and it succeeds.

Notes:

* The conversion of `cost.to_f` is because we need decimal division, rather than integer division.

* In a real program, we would likely create a method `main` that sets up the environment such as requiring libraries and initializing a logger, and a method `run` that does the purpose of the program such as reading input, processing data, results, and printing results.


## Step 2: Simple offers

The shop decides to introduce two new offers: 

* Buy one, get one free on apples.

* 3 for the price of 2 on oranges.
  
Update your checkout functions accordingly.


## Requirement: Add offers

**Setup:** We want an offer that can decide if a discount applies, and if so, for how much:

```sh
touch lib/offer.rb
touch test/test_offer.rb
```

We recognize that "Buy one get one free" is equivalent to "2 for the price of 1". Thus both offers are "X for the price of Y", so we'll code it that way.

**TDD:** Edit `test_offer.rb` and add tests for a new method `x_for_price_of_y`. 

* We want an assertion for each kind of offer when it's included in the total cost i.e. when the offer is applicable thus the method returns a discount.

* We want an assertion for each kind of offer when it's excluded in the total cost i.e. when the offer is inapplicable thus the method returns no discount). 

* Thus we're writing one conceptual test i.e. TDD style, with four test methods, each with one assertion. This is still true TDD, because the purpose is one concept. 

* Some people prefer to apprpoach this kind of TDD step-by-step with smaller code, such as writing one test that doesn't implement any offer and simply returns a constant 0; this step-by-step can be fine for bootstraping or exploring a new area, however that simple code is better retired in favor of tests with coverage of real cases. In the interest of space, the tests below show the outcome rather than the bootstrapping.

```ruby
require 'minitest/autorun'
require './lib/offer'

class TestOffer < Minitest::Test

    def test_x_for_price_of_y_with_2_for_1_apples_include
        items = ["apple", "apple"]
        assert_equal -60, Offer.x_for_price_of_y(items, 2, 1, "apple")
    end

    def test_x_for_price_of_y_with_2_for_1_apples_exclude
        items = ["apple"]
        assert_equal 0, Offer.x_for_price_of_y(items, 2, 1, "apple")
    end

    def test_x_for_price_of_y_with_3_for_2_oranges_include
        items = ["orange", "orange", "orange"]
        assert_equal -25, Offer.x_for_price_of_y(items, 3, 2, "orange")
    end

    def test_x_for_price_of_y_with_3_for_2_oranges_exclude
        items = ["orange", "orange"]
        assert_equal 0, Offer.x_for_price_of_y(items, 3, 2, "orange")
    end

end
```

Run `rake` and it fails as planned.

**Implement:** Edit `offer.rb` and create the method `x_for_price_of_y`:

```ruby
class Offer

    def self.x_for_price_of_y(items, item)
        (items.count(item) / x) * (x - y) * -Shop.item_cost(item)
    end

end
```

Run `rake` and it should succeed for `Offer.x_for_price_of_y` but fail for `Till.total_cost` because we haven't updated it.


**TDD:** Edit `test_till.rb` and update `test_total_cost_*` with new offer tests that test the combination of both offers:

```ruby
def test_total_cost_with_2_for_1_apples_include_and_3_for_2_oranges_include
    items = ["apple", "apple", "orange", "orange", "orange"]
    assert_equal 110, Till.total_cost(items)
end

def test_total_cost_with_2_for_1_apples_exclude_and_3_for_2_oranges_exclude
    items = ["apple", "orange", "orange"]
    assert_equal 110, Till.total_cost(items)
end
```

Run `rake` and it fails as planned.

**Implement:** Edit `till.rb` and add the offers: 

```ruby
def self.total_cost(items)
    items.map{|item| SHOP[item]}.sum +
    Offer.x_for_price_of_y(items, 2, 1, "apple") +
    Offer.x_for_price_of_y(items, 3, 2, "orange")
end
```

Run `rake` and it should succeed for the new `Till` tests, but fail for the existing `Till` test `test_total_cost_*` because we haven't updated it.

**TDD:** Edit `test_till.rb` and replace the test `test_total_cost_*` with a method `test_subtotal_cost_*`:

```ruby
def test_subtotal_cost_with_example_list
    items = ["apple", "apple", "orange", "apple"]
    assert_equal(205, Till.subtotal_cost(items))
end
```

Run `rake` and it fails as planned.

**Implement:** Edit `till.rb` and update the method `total_cost` and create the method `subtotal_cost`:

```ruby
def self.subtotal_cost(items)
    items.map{|item| SHOP[item]}.sum
end
```

Run `rake` and it succeeds.

**Refactor:** Edit `till.rb` to use the new method `subtotal_cost`:

```ruby
def self.total_cost(items)
    self.subtotal_cost(items) +
    Offer.x_for_price_of_y(items, 2, 1, "apple") +
    Offer.x_for_price_of_y(items, 3, 2, "orange")
end
```

Run `rake` and it should succed.

Notes:

* We favor a functional-style multiline calculation, rather than a mutation-style one-line-at-a-time calculation.

* In a real application, we would likely write more tests, such as for edge cases (e.g. when there are no items) and for larger cases (e.g. when there are many apple and many oranges).


## Step 3: More complicated offers

The shop adds bananas.

* Bananas cost 20 cents each.

* Bananas are added to the same buy one get one free offer as apples.

* The cheapest item should be given free first.

Update your checkout functions accordingly.


## Requirement: Add bananas that cost 20 cents

**TDD:** Edit `test_shop.rb` and add:

```ruby
def test_item_cost_with_banana
    item = "banana"
    assert_equal 0.20, Demo.item_cost(item)
end
```

Run `rake` and it fails as planned.

**Implement:** Edit `shop.rb` and add lines for the banana:

```ruby
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
```

Run `rake` and it succeeds.


## Requirement: Add bananas offer of buy one get one free

**TDD:** Edit `test_offer.rb` and add tests for `x_for_price_of_y_with_2_for_1_bananas` that are akin to the tests for apples and oranges:

```ruby
def test_x_for_price_of_y_with_2_for_1_bananas_include
    items = ["banana", "banana"]
    assert_equal -20, Offer.x_for_price_of_y(items, 2, 1, "banana")
end

def test_x_for_price_of_y_with_2_for_1_bananas_exclude
    items = ["banana"]
    assert_equal 0, Offer.x_for_price_of_y(items, 2, 1, "banana")
end
```

Run `rake` and it should succeed for the new tests because the implementation method already exists, but fail for the outdated tests `Till.total_cost_*`.

**TDD:** Edit `test_till.rb` and update the methods `test_total_cost_*` to:

```ruby
def test_total_cost_with_2_for_1_apples_exclude_and_2_for_1_bananas_exclude_and_3_for_2_oranges_exclude
    items = ["apple", "banana", "orange", "orange"]
    assert_equal 130, Till.total_cost(items)
end

def test_total_cost_with_2_for_1_apples_include_and_2_for_1_bananas_include_and_3_for_2_oranges_include
    items = ["apple", "apple", "banana", "banana", "orange", "orange", "orange"]
    assert_equal 130, Till.total_cost(items)
end
```

**Implement:** Edit `till.rb` and add one line for the new offer:

```ruby
def self.total_cost(items)
    self.subtotal_cost(paid_items) +
    Offer.x_for_price_of_y(items, 2, 1, "apple") +
    Offer.x_for_price_of_y(items, 2, 1, "banana") +
    Offer.x_for_price_of_y(items, 3, 2, "orange")
end
```

Run `rake` and it succeeds.


## Requirement: The cheapest item should be given free first

**TDD:** Edit `test_till.rb` and add a test:

```ruby
def test_total_cost_with_cheapest_item_free
    items = ["apple", "banana", "orange"]
    assert_equal 85, Till.total_cost(items)
end
```

Run `rake` and it fails as planned.

**Implement:** Edit `till.tb` and add a line that decides which item is free and which items are paid:

```ruby
def self.total_cost(items)
    _free_item, *paid_items = self.sort_by_cost(items)
    self.subtotal_cost(paid_items) +
    Offer.x_for_price_of_y(paid_items, 2, 1, "apple") +
    Offer.x_for_price_of_y(paid_items, 2, 1, "banana") +
    Offer.x_for_price_of_y(paid_items, 3, 2, "orange")
end

def self.sort_by_cost(items)
    items.sort_by{|itemj| Till.item_cost(item)}
end
```

Run `rake` and it succeeds.
