# Fakeshop

Fakeshop is a proof of concept e-commerce shopping application I built to solidify my understanding of building and testing Ruby on Rails applications. Fakeshop allows users to browse a catalogue of products, add a quantity of each item to the shopping cart and place an order. The admin can view, add, edit or delete the current products in the catalougue as well as accept and ship orders for delivery. 

## Features
- **Users Features**
  - Browse the catalogue of products available to buy, select a quantity of the item and add to the shopping cart
  - View the Order summary in the cart and place an order
  - Receive an email notification when the order have been placed

- **Admin Features**
  - View, add, edit and delete the current products in the catalogue
  - View orders which havent shipped yet
  - Ship orders for delivery, which will send a notification to the user
  - View Users who has bought speficic products


## How to run locally
### Prerequisites

  - Ruby 2.7.0
  - rails 6.0
  - postgres 12.16

### Installation

1. Clone the repository and navigate to it:
```sh
git clone git@github.com:junior451/fakeshop.git && cd fakeshop
```

2. Install Rails dependencies
```sh
bundle install
```

3. Setup the database:
```sh
rails db:create && rails db:migrate && rails db:seed
```

4. Start the rails server
```sh
rails s
```

5. Navigate to `localhost:3000` in a web browser