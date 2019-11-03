require 'pry'

def find_item_by_name_in_collection(name, collection)

  collection.each do |item|
    if item[:item] == name
      return item
    end
  end

  return nil
end

def consolidate_cart(cart)
  # This part feels really confusing. Do they want an Array back or a hash? It seems like they want an array of hashes back. Seems like it would take more work to access items from it then to check if they are duplicates. I had to make a hash first then add those items to an array.
  hash = {}
  new_array = []
  cart.each do |item|
    item_name = item.values[0]
    if hash[item_name]
      hash[item_name][:count] += item[:count]
    else 
      hash[item_name] = {
        item: item_name,
        price: item[:price],
        clearance: item[:clearance],
        count: item[:count]
      }
    end
  end
 
  hash.each do |key, value|
    new_array.push(value)
  end
  new_array
end

def consolidate_cart_hash(cart)
  # This part feels really confusing. Do they want an Array back or a hash? It seems like they want an array of hashes back. Seems like it would take more work to access items from it then to check if they are duplicates. I had to make a hash first then add those items to an array.
  hash = {}
  new_array = []
  cart.each do |item|
    item_name = item.values[0]
    binding.pry
    if hash[item_name]
      hash[item_name][:count] += 1
    else 
      hash[item_name] = {
        price: item[:price],
        clearance: item[:clearance],
        count: 1
      }
    end
  end
 
  # hash.each do |key, value|
  #   new_array.push(value)
  # end
  # new_array
  hash
end

def apply_coupons(cart, coupons)
  consolidated_cart = consolidate_cart_hash(cart)

  coupons.each do |coupon|
    coupon_item = coupon[:item]
    
    # cart.each do |cart_item|
    #   # binding.pry
    #   if coupon_item == cart_item[:item] && cart_item[:count] >= coupon[:num]
    #     cart_coupon = "#{coupon_item} W/COUPON"
    #     binding.pry

    #     # Now that it's an Array of hashes this part is far more difficult. We can't just see if that coupon already exists in the hash.
    #     if cart[cart_coupon]
    #       cart[cart_coupon][:count] += 1
    #     else
    #       cart.push({
    #         item: cart_item[:item],
    #         price: cart_item[:price],
    #         clearance: cart_item[:clearance],
    #         count: 1
    #       })
    #     end
    #     cart_item[:count] -= coupon[:count]
    #   end
    # end
    consolidated_cart.each do |item_name, item_info|
      

      binding.pry
      if item_name == coupon_item && item_info[:count] >= coupon[:num]
        cart_coupon = "#{coupon_item} W/COUPON"

        if consolidated_cart[cart_coupon]
          consolidated_cart[cart_coupon][:count] += 1
        else
          consolidated_cart[cart_coupon] = {
            price: coupon[:price]
          }
        end
      end
    end

  end
  cart
end

def apply_clearance(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
end

def checkout(cart, coupons)
  # Consult README for inputs and outputs
  #
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers
end
