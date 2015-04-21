class AccessCodeDistributionController < ApplicationController
  # before_filter :get_access_code, only: [:index]
  
  def index
    
    @order_id = params[:id]
  end
  
  def add_note_attribute
    
  end
  
  def retrieve_existing_access_code
    
    response_code = 0
    message = ""
    note_attributes = []
    item_index = 1
    
    order_id = params[:order_id]
    
    result = load_shopify_order_data(order_id)
    response_code = result[:response_code]

    unless response_code == 200
      render json: {response_code: response_code, message: "get shopify order data failed"}.to_json and return
    end
    
    product_ids = ""
    order_line_items = result[:message]["line_items"]

    order_line_items.each_with_index do |item, index|

      if index == order_line_items.length - 1
        product_ids += item["product_id"].to_s
      else
        product_ids += item["product_id"].to_s + ","
      end

    end
    
    result = ajax_get_shopify_product_type2(product_ids)
    response_code = result[:response_code]

    unless response_code == 200
      render json: {response_code: response_code, message: "get shopify product type failed"}.to_json and return
    end
    
    product_types = result[:message]
    
    begin
      
      # book_codes = BookCode.where("shopify_order_id=" + order_id + " and shopify_line_item_id>0")
      # digital_codes = DigitalCode.where("shopify_order_id=" + order_id + " and shopify_line_item_id>0")
      #
      # total_codes = book_codes + digital_codes
      # total_codes = total_codes.sort_by{ |total_code| total_code[:shopify_line_item_id]}
      
      # total_codes.each_with_index do |total_code, index|
      #
      #   note_attributes << {:name => "activation_code" + item_index.to_s, :value => total_code.code}
      #   item_index += 1
      #
      # end
      
      order_line_items.each_with_index do |item, index|
        
        product_types.each do |p|
                  
          if item["product_id"] == p["id"]

            item["type"] = p["product_type"]

          end
          
        end

      end
      
      order_line_items.each_with_index do |item, index|

        quantity = item["quantity"].to_i
        
        if item["type"] == "Book"

          item["display"] = 1

          old_codes = BookCode.where(:shopify_order_id => order_id.to_i, :shopify_product_id => item["product_id"].to_i, :shopify_line_item_id => item["id"].to_i).order(:id).take(quantity)

          need_new_code_count = quantity - old_codes.count
          codes = ""
          
          if need_new_code_count > 0
            item["has_code"] = 0
          else
            item["has_code"] = 1
          end

          old_codes.each_with_index do |book_code, index|

            if index == old_codes.count - 1
              codes += book_code.code
            else
              codes += book_code.code + ";"
            end

            # note_attributes << {:name => "activation_code" + item_index.to_s, :value => book_code.code}
#             item_index += 1

          end

          item["codes"] = codes

        elsif item["type"] == "Digital Membership"

          item["display"] = 1

          old_codes = DigitalCode.where(:shopify_order_id => order_id.to_i, :shopify_product_id => item["product_id"].to_i, :shopify_line_item_id => item["id"].to_i).order(:id).take(quantity)

          need_new_code_count = quantity - old_codes.count
          codes = ""
          
          if need_new_code_count > 0
            item["has_code"] = 0
          else
            item["has_code"] = 1
          end

          old_codes.each_with_index do |digital_code, index|

            if index == old_codes.count - 1
              codes += digital_code.code
            else
              codes += digital_code.code + ";"
            end

            # note_attributes << {:name => "activation_code" + item_index.to_s, :value => digital_code.code}
 #            item_index += 1

          end

          item["codes"] = codes

        else

          item["display"] = 0

        end

      end
      
      response_code = 200
      
    rescue => exception
      
      response_code = 500
      message = "Retrieve access_code error order_id: " + order_id + " message: " + exception.message
      puts "Retrieve access_code error order_id: " + order_id + " message: " + exception.message

    end
    
    render json: {response_code: response_code, message: message, order_line_items: order_line_items}.to_json
    
  end
  
  def update_existing_access_code
    
    response_code = 0
    message = ""
    note_attributes = []
    item_index = 1
    
    order_id = params[:order_id]
    
    begin
    
      book_codes = BookCode.where("shopify_order_id=" + order_id + " and shopify_line_item_id>0")
      digital_codes = DigitalCode.where("shopify_order_id=" + order_id + " and shopify_line_item_id>0")
      
      total_codes = book_codes + digital_codes
      total_codes = total_codes.sort_by{ |total_code| total_code[:shopify_line_item_id]}
      
      total_codes.each_with_index do |total_code, index|
        
        note_attributes << {:name => "activation_code" + item_index.to_s, :value => total_code.code}
        item_index += 1
        
      end
      
      result = add_note_attributes_to_order(order_id, note_attributes)
      
      response_code = 200
      
    rescue => exception
      
      response_code = 500
      puts "Update existing access_code error order_id: " + order_id + " message: " + exception.message

    end
    
    render json: {response_code: response_code, message: message}.to_json
    
  end
  
  def get_access_code

    order_id = params[:order_id]
    # order_id = "300512711"
    
    result = load_shopify_order_data(order_id)
    response_code = result[:response_code]

    unless response_code == 200
      render json: {response_code: response_code, message: "get shopify order data failed"}.to_json and return
    end
    
    product_ids = ""
    order_line_items = result[:message]["line_items"]

    order_line_items.each_with_index do |item, index|

      if index == order_line_items.length - 1
        product_ids += item["product_id"].to_s
      else
        product_ids += item["product_id"].to_s + ","
      end

    end

    result = ajax_get_shopify_product_type(order_id, product_ids, order_line_items)
    response_code = result[:response_code]

    unless response_code == 200
      render json: {response_code: response_code, message: "get access code failed"}.to_json and return
    end

    note_attributes = result[:note_attributes]
    need_update_note_attributes = result[:need_update_note_attributes]
    # puts result[:note_attributes]

    if need_update_note_attributes
      result = add_note_attributes_to_order(order_id, note_attributes)
    end
    
    render json: {response_code: 200, line_items: order_line_items}.to_json
    
  end
  
  def ajax_get_shopify_product_type2(product_ids)
    
    require 'net/http'

    response_code = 0
    message = ""
    note_attributes = []
    need_update_note_attributes = false
    
    begin

      uri = URI(Rails.configuration.shopify_url + 'admin/products.json?ids=' + product_ids + '&fields=id,product_type')

      Net::HTTP.start(uri.host, uri.port,
        :use_ssl => uri.scheme == 'https') do |http|
        request = Net::HTTP::Get.new uri
        request.basic_auth(Rails.configuration.shopify_apikey,Rails.configuration.shopify_password)

        response = http.request(request)
        response_code = Integer(response.code)
        
        if response.code == "200"
            @json = JSON.parse(response.body)
            message = @json["products"]
        else
          puts "Shopify products api return failure response order_id: " + order_id + " response_code: " + response.code + " message: " + response.body
          response_code = 500
        end

      end

    rescue => exception

      puts "There is an exception when call shopify products api, order_id: " + order_id + " message: " + exception.message
      response_code = 500

    end
    
    {response_code: response_code, message: message}
    
  end
  
  def load_shopify_order_data(order_id)
    
    require 'net/http'

    response_code = 0
    message = ""

    begin

      uri = URI(Rails.configuration.shopify_url + 'admin/orders/' + order_id + '.json?fields=line_items')

      Net::HTTP.start(uri.host, uri.port,
        :use_ssl => uri.scheme == 'https') do |http|
        request = Net::HTTP::Get.new uri
        request.basic_auth(Rails.configuration.shopify_apikey,Rails.configuration.shopify_password)

        response = http.request(request)
        response_code = Integer(response.code)
        
        if (response.code == "200")
            @json = JSON.parse(response.body)
            message = @json["order"]
        else
            puts "Shopify order api return failure response order_id: " + order_id + " response_code: " + response.code + " message: " + response.body
        end

      end

    rescue => exception
      
      response_code = 500
      puts "There is an exception when call shopify order api, order_id: " + order_id + " message: " + exception.message

    end
    
     {response_code: response_code, message: message}
     
  end
  
  def ajax_get_shopify_product_type(order_id, product_ids, order_line_items)
    
    require 'net/http'

    response_code = 0
    message = ""
    note_attributes = []
    need_update_note_attributes = false
    
    begin

      uri = URI(Rails.configuration.shopify_url + 'admin/products.json?ids=' + product_ids + '&fields=id,product_type')

      Net::HTTP.start(uri.host, uri.port,
        :use_ssl => uri.scheme == 'https') do |http|
        request = Net::HTTP::Get.new uri
        request.basic_auth(Rails.configuration.shopify_apikey,Rails.configuration.shopify_password)

        response = http.request(request)
        response_code = Integer(response.code)
        
        if (response.code == "200")
          
            @json = JSON.parse(response.body)
            
            products = @json["products"]
            item_index = 1
            
            order_line_items.each_with_index do |item, index|
        
              products.each do |p|
                
                if item["product_id"] == p["id"]
                  
                  quantity = item["quantity"].to_i
                  
                  if p["product_type"] == "Book"
                    
                    item["display"] = 1
                    old_codes = []
                    new_codes = []
                    
                    old_codes = BookCode.where(:shopify_order_id => order_id.to_i, :shopify_product_id => item["product_id"].to_i, :shopify_line_item_id => item["id"].to_i).order(:id).take(quantity)
                    need_new_code_count = quantity - old_codes.count
                    
                    if need_new_code_count > 0
                      
                      need_update_note_attributes = true
                      new_codes = BookCode.where("shopify_order_id = 0").order(:id).take(need_new_code_count)
                      
                      BookCode.transaction do
                      
                        new_codes.each do |book_code|
                      
                          book_code.shopify_order_id = order_id
                          book_code.shopify_product_id = item["product_id"].to_i
                          book_code.shopify_line_item_id = item["id"].to_i
                          book_code.save
                      
                        end
                      
                      end
                      
                      need_new_code_count = need_new_code_count - new_codes.count
                      
                    end
                    
                    if need_new_code_count > 0
                      item["has_code"] = 0
                    else
                      item["has_code"] = 1
                    end
                    
                    total_codes = old_codes + new_codes
                    codes = ""
                    
                    total_codes.each_with_index do |book_code, index|
                      
                      if index == total_codes.count - 1
                        codes += book_code.code
                      else
                        codes += book_code.code + ";"
                      end
                      
                      note_attributes << {:name => "activation_code" + item_index.to_s, :value => book_code.code}
                      item_index += 1
                      
                    end
                    
                    item["codes"] = codes
                    
                  elsif p["product_type"] == "Digital Membership"
                    
                    item["display"] = 1
                    old_codes = []
                    new_codes = []
                    
                    old_codes = DigitalCode.where(:shopify_order_id => order_id.to_i, :shopify_product_id => item["product_id"].to_i, :shopify_line_item_id => item["id"].to_i).order(:id).take(quantity)
                    need_new_code_count = quantity - old_codes.count
                    
                    if need_new_code_count > 0
                    
                      need_update_note_attributes = true
                      new_codes = DigitalCode.where("shopify_order_id = 0").order(:id).take(need_new_code_count)
                      
                      DigitalCode.transaction do
                      
                        new_codes.each do |digital_code|
                      
                          digital_code.shopify_order_id = order_id
                          digital_code.shopify_product_id = item["product_id"].to_i
                          digital_code.shopify_line_item_id = item["id"].to_i
                          digital_code.save
                      
                        end
                      
                      end

                      need_new_code_count = need_new_code_count - new_codes.count
                      
                    end
                    
                    if need_new_code_count > 0
                      item["has_code"] = 0
                    else
                      item["has_code"] = 1
                    end
                    
                    total_codes = old_codes + new_codes
                    codes = ""
                    
                    total_codes.each_with_index do |digital_code, index|
                      
                      if index == total_codes.count - 1
                        codes += digital_code.code
                      else
                        codes += digital_code.code + ";"
                      end
                      
                      note_attributes << {:name => "activation_code" + item_index.to_s, :value => digital_code.code}
                      item_index += 1
                      
                    end
                    
                    item["codes"] = codes
                    
                  else
                    
                    item["display"] = 0
                    
                  end
                            
                end
          
              end
        
            end
            
        else
            puts "Shopify products api return failure response order_id: " + order_id + " response_code: " + response.code + " message: " + response.body
            response_code = 500
        end

      end

    rescue => exception

      puts "There is an exception when call shopify products api, order_id: " + order_id + " message: " + exception.message
      response_code = 500

    end
    
    {response_code: response_code, note_attributes: note_attributes, need_update_note_attributes: need_update_note_attributes}
    
  end
  
  def add_note_attributes_to_order(order_id, note_attributes)
    
    require 'net/http'

    response_code = 0
    message = ""
    
    try_times = 0
    max_try_times = 3
    
    while try_times < max_try_times do
      
      begin
          
        # puts "aa" + try_times
        uri = URI(Rails.configuration.shopify_url + 'admin/orders/' + order_id + '.json')

        Net::HTTP.start(uri.host, uri.port,
          :use_ssl => uri.scheme == 'https') do |http|
          request = Net::HTTP::Put.new uri
          request.basic_auth(Rails.configuration.shopify_apikey,Rails.configuration.shopify_password)

          request.add_field('Content-Type', 'application/json')

          request.body = {
            order: {
              id: order_id,
              note_attributes: note_attributes
            }
          }.to_json

          response = http.request(request)
          response_code = Integer(response.code)
        
          puts note_attributes
          if response.code != "200"
              puts "Shopify add_note_attributes api return failure response order_id: " + order_id + " try times: " + (try_times + 1).to_s + " response_code: " + response.code + " message: " + response.body
          else
              puts "Shopify add_note_attributes success" + " order_id:" + order_id + " try times: " + (try_times + 1).to_s
          end

        end

      rescue => exception
      
        response_code = 500
        puts "There is an exception when call shopify add_note_attributes api, order_id: " + order_id + " try times: " + (try_times + 1).to_s + " message: " + exception.message

      end
      
      if response_code == 200
        
        book_codes = BookCode.where(:shopify_order_id => order_id.to_i)
        BookCode.transaction do

          book_codes.each do |code|

            code.is_saved_to_shopify = true
            code.save

          end

        end
        
        digital_codes = DigitalCode.where(:shopify_order_id => order_id.to_i)
        DigitalCode.transaction do

          digital_codes.each do |code|

            code.is_saved_to_shopify = true
            code.save

          end

        end
        
        break
        
      end
      
      try_times += 1
      
      if try_times == 2
        
        book_codes = BookCode.where(:shopify_order_id => order_id.to_i)
        BookCode.transaction do

          book_codes.each do |code|

            code.is_saved_to_shopify = false
            code.save

          end

        end
        
        digital_codes = DigitalCode.where(:shopify_order_id => order_id.to_i)
        DigitalCode.transaction do

          digital_codes.each do |code|

            code.is_saved_to_shopify = false
            code.save

          end

        end
        
      end
      
    end
    
    {response_code: response_code, message: message}
    
     
  end
  
  # def send_notification_email(title, order_id, response_code, message)
#
#     begin
#
#       reason = title + " response_code: " + response_code + " message: " + message
#       AdminMailer.failure_membership_notification(customer_name, customer_email, order_id, product_id, product_title, reason).deliver
#
#     rescue => exception
#
#         puts "There is an exception when send notification email message: " + exception.message + " customerName: " + customer_name + " customerEmail: " + customer_email + " order_id: " + order_id + " product_id: " + product_id + " product_title: " + product_title
#
#     end
#
#   end
  
end