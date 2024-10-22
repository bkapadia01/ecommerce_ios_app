# ecommerce_ios_app
This is an eCommerce ios app built using [fake store api](https://fakestoreapi.com/).
The app is designed to respect the MVVM architecture model.

## Sign In / Registration page
- user validation on the sign-in:
  - field completion
  - validate entered username/password

- registration for creating new account:
  - validate all fields completed
  - validate username and password are greater than or equal to 5 chars long 
  - validate username does not already exist in db
  - confirm user registration completes successfully

<img src="https://user-images.githubusercontent.com/26723281/204707648-d2a69892-116c-4def-bc2b-4eb624d48ea1.png" width="158">  <img src="https://user-images.githubusercontent.com/26723281/204707046-bfa3b621-a8f6-4f2b-9096-39d5531d5fc0.png" width="158">

## Homepage
- In the homepage view, the user can:
  - See all the product with the name and image of each item
  - Has the ability to click on a product and be directed to the product detail view
- In the product detail view the user can:
  - Return to the home page collection view
  - View product image, title as well as product detail description, product price 
  - Select option to add the product to the cart
  - Receive a successful alert if the product is added to the cart successfully

<img src="https://user-images.githubusercontent.com/26723281/204707054-860a68a1-79d2-4052-9ce6-dd192cf7da21.png" width="158">  <img src="https://user-images.githubusercontent.com/26723281/204707826-dea99bfc-e5bd-4deb-a50f-4bf73a1dca84.png" width="158">


## Cart
- In the cart view, the user can:
  - See all product added to the cart by the user with the name and image of each item
  - view that the cart is empty when there are no items in the cart
  - Edit the cart and delete items from the cart
  - Checkout/Pay for all items in the cart
  
<img src="https://user-images.githubusercontent.com/26723281/204707048-f377ba2a-a2a2-4655-a5e2-3fb575fd50d9.png" width="158">  <img src="https://user-images.githubusercontent.com/26723281/204708572-21bef965-ba7d-41ee-b973-8d3e7b642696.png" width="158">  <img src="https://user-images.githubusercontent.com/26723281/204708761-a55f9cc5-0270-4654-b5aa-e38263503eee.png" width="158">  <img src="https://user-images.githubusercontent.com/26723281/204714451-f3ad80c5-3a3c-44e0-b2bb-d12edd90d509.png" width="158"> 

## Profile
- In the profile view, the user can:
  - see their first name, last name and username
  - see the purchase history of each item the date, time and total cost of the checkouted items
  - option to logout from the app and return to login page

<img src="https://user-images.githubusercontent.com/26723281/204707052-0d48ce35-710c-42b3-b897-9fc0b39dcbfb.png" width="158">  <img src="https://user-images.githubusercontent.com/26723281/204714115-f7af07b3-fef2-414f-b10f-c8d94ebe43be.png" width="158">


## Table Graph Model
<img src="https://user-images.githubusercontent.com/26723281/204708907-bfae74fc-6254-4b9e-a447-1c31d2f69455.png" width="800">

