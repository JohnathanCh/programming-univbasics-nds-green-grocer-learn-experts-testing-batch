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
      hash[item_name][:count] += 1
    else 
      hash[item_name] = {
        item: item_name,
        price: item[:price],
        clearance: item[:clearance],
        count: 1
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
    # binding.pry
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
 
  # hash.each do |key, value|
  #   new_array.push(value)
  # end
  # new_array
  hash
end

def apply_coupons(cart, coupons)
  consolidated_cart = consolidate_cart_hash(cart)
  hash = consolidated_cart.clone
  new_array = []

  # Now that it's an Array of hashes this part is far more difficult. We can't just see if that coupon already exists in the hash.
  if !coupons.empty? 
    coupons.each do |coupon|
      coupon_item = coupon[:item]
      consolidated_cart.each do |item_name, item_info|
        
        if item_name == coupon_item && item_info[:count] >= coupon[:num]
          cart_coupon = "#{coupon_item} W/COUPON"
          if hash[cart_coupon]
            hash[cart_coupon][:count] += coupon[:num]
          else
            hash[cart_coupon] = {
              item: cart_coupon,
              price: coupon[:cost]/coupon[:num],
              count: coupon[:num],
              clearance: item_info[:clearance]
            }
          end
          hash[item_name][:count] -= coupon[:num]
        end
      end
  end
end

hash.each do |item_name, item_info|
  new_array.push(item_info)
end
  return new_array
end

def apply_clearance(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  # binding.pry
  cart.each do |item|
    if item[:clearance]
      item[:price] = (item[:price] * 0.8).round(2)
    end
  end
  cart
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

  total = 0

  consolidated_cart = consolidate_cart(cart)
  cart_with_coupons_applied = apply_coupons(consolidated_cart, coupons)
  cart_with_clerance_applied = apply_clearance(cart_with_coupons_applied)
  
  cart_with_clerance_applied.each do |item|
    total += (item[:price] * item[:count])
  end

  if total >= 100
    total = (total * 0.9)
  end
  total
end
