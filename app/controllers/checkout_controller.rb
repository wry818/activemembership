class CheckoutController < ApplicationController
  layout 'checkout/layouts/application'
  before_filter :load_shopify_product_data, only: [:index]
  before_filter :load_shopify_order_data, only: [:thank_you]
  
  def index
    @product_id = params[:product_id]
    @plan = params[:plan]
  end
  
  def continue
    
  end
  
  def payment
    @product_id = params[:product_id]
    @plan = params[:plan]
  end
  
  def thank_you
    @order_id = params[:order_id]
  end
  
  def ajax_create_subscription
    
    token_id = params[:token_id]
    plan_code = params[:plan_code]
    email = params[:email]
    variant_id = params[:variant_id]
    
    first_name = params[:shipping_address][:first_name]
    last_name = params[:shipping_address][:last_name]
    address1 = params[:shipping_address][:address1] 
    address2 = params[:shipping_address][:address2]
    phone = params[:shipping_address][:phone] 
    city = params[:shipping_address][:city] 
    province = params[:shipping_address][:province]
    country = params[:shipping_address][:country] 
    zip = params[:shipping_address][:zip]
    
    billing_first_name = params[:billing_address][:first_name]
    billing_last_name = params[:billing_address][:last_name]
    billing_address1 = params[:billing_address][:address1] 
    billing_address2 = params[:billing_address][:address2]
    billing_phone = params[:billing_address][:phone] 
    billing_city = params[:billing_address][:city] 
    billing_province = params[:billing_address][:province]
    billing_country = params[:billing_address][:country] 
    billing_zip = params[:billing_address][:zip]
    
    product_title = params[:product_title]
    product_description = params[:product_description]
    
    result = get_shopify_customer(email)
    response_code = result[:response_code]

    unless response_code == 200
      render json: {code: 998, message: "get shopify customer failed"}.to_json and return
    end

    customer_id = result[:message]

    unless customer_id != ""

      result = create_shopify_customer(email, first_name, last_name, address1, address2, phone, city, province, country, zip)
      response_code = result[:response_code]

      unless response_code == 201
        render json: {code: 998, message: "create shopify customer failed"}.to_json and return
      end

      customer_id = result[:message]

    end

    # render json: {code: response_code, message: customer_id}.to_json
    result = create_recurly_subscription(customer_id, token_id, plan_code, email, product_title, product_description)
    response_code = result[:response_code]

    unless response_code == 200
      if response_code == 999
        render json: {code: response_code, message: result[:message]}.to_json and return
      else
        render json: {code: response_code, message: "create recurly subscription failed"}.to_json and return
      end
    end

    subscription_code = result[:message]
    result = create_shopify_order(subscription_code, customer_id, email, variant_id, first_name, last_name, address1, address2, phone, city, province, country, zip, billing_first_name, billing_last_name, billing_address1, billing_address2, billing_phone, billing_city, billing_province, billing_country, billing_zip)
    response_code = result[:response_code]

    if response_code == 201

      order_id = result[:message]

      #result = update_recurly_subscription_note(subscription_code, order_id, product_title, product_description)
      render json: {code: response_code, message: order_id}.to_json

    else

      render json: {code: response_code, message: "create shopify order failed"}.to_json

    end
    
  end
  
  private
  
  def load_shopify_product_data
    
    require 'net/http'

    @result = ""
    @product_id = params[:product_id]

    begin

      uri = URI(Rails.configuration.shopify_url + 'admin/products/' + @product_id + '.json?fields=id,product_type,images,title,variants')

      Net::HTTP.start(uri.host, uri.port,
        :use_ssl => uri.scheme == 'https') do |http|
        request = Net::HTTP::Get.new uri
        request.basic_auth(Rails.configuration.shopify_apikey,Rails.configuration.shopify_password)

        response = http.request(request)

        if (response.code == "200")
            @json = JSON.parse(response.body)
            @result = {code: Integer(response.code), data: @json["product"]}.to_json
        else
            puts "Shopify product api return failure response, response_code: " + response.code + " message: " + response.body + " product_id:" + @product_id
            @result = {code: Integer(response.code)}.to_json
        end

      end

    rescue => exception

      puts "There is an exception when call shopify product api, product_id: " + @product_id + " message: " + exception.message
      @result = {code: 500, message: exception.message}.to_json

    end
    
  end
  
  def load_shopify_order_data
    
    require 'net/http'

    @result = ""
    @order_id = params[:order_id]

    begin

      uri = URI(Rails.configuration.shopify_url + 'admin/orders/' + @order_id + '.json?fields=name,customer,line_items')

      Net::HTTP.start(uri.host, uri.port,
        :use_ssl => uri.scheme == 'https') do |http|
        request = Net::HTTP::Get.new uri
        request.basic_auth(Rails.configuration.shopify_apikey,Rails.configuration.shopify_password)

        response = http.request(request)

        if (response.code == "200")
            @json = JSON.parse(response.body)
            @result = {code: Integer(response.code), data: @json["order"]}.to_json
        else
            puts "Shopify order api return failure response, response_code: " + response.code + " message: " + response.body + " order_id:" + @order_id
            @result = {code: Integer(response.code)}.to_json
        end

      end

    rescue => exception

      puts "There is an exception when call shopify order api, order_id: " + @order_id + " message: " + exception.message
      @result = {code: 500, message: exception.message}.to_json

    end
    
  end
  
  def get_shopify_customer(customer_email)
    
    require 'net/http'
    
    response_code = 0
    message = ""

    begin

      uri = URI(Rails.configuration.shopify_url + 'admin/customers/search.json?query=' + customer_email)

      Net::HTTP.start(uri.host, uri.port,
        :use_ssl => uri.scheme == 'https') do |http|
        request = Net::HTTP::Get.new uri
        request.basic_auth(Rails.configuration.shopify_apikey,Rails.configuration.shopify_password)

        response = http.request(request)
        response_code = Integer(response.code)
        
        if (response.code == "200")
            
            @json = JSON.parse(response.body)
            
            if @json["customers"] && @json["customers"][0]

              message = @json["customers"][0]["id"]

            end
            
        else
            puts "Shopify customer api return failure response, response_code: " + response.code + " message: " + response.body + " email_address:" + customer_email
        end

      end

    rescue => exception

      response_code = 500
      puts "There is an exception when call shopify customer api, email_address: " + customer_email + " message: " + exception.message

    end
      
    {response_code: response_code, message: message}
    
  end
  
  def create_shopify_customer(customer_email, first_name, last_name, address1, address2, phone, city, province, country, zip)
    
    require 'net/http'
    
    response_code = 0
    message = ""

    begin

      uri = URI(Rails.configuration.shopify_url + 'admin/customers.json')
      
      Net::HTTP.start(uri.host, uri.port,
        :use_ssl => uri.scheme == 'https') do |http|
        request = Net::HTTP::Post.new uri
        request.basic_auth(Rails.configuration.shopify_apikey,Rails.configuration.shopify_password)

        request.add_field('Content-Type', 'application/json')
        request.body = {
          customer: {
            first_name: first_name,
            last_name: last_name,
            email: customer_email,
            addresses: [
              {
                address1: address1,
                address2: address2,
                city: city,
                province: province,
                phone: phone,
                zip: zip,
                last_name: first_name,
                first_name: last_name,
                country: country
              }
            ]
          }
        }.to_json
        
        response = http.request(request)
        response_code = Integer(response.code)
        
        if (response.code == "201")
            
            # puts response.body
            @json = JSON.parse(response.body)
            message = @json["customer"]["id"]
            
        else
            puts "Shopify create customer api return failure response, response_code: " + response.code + " message: " + response.body + " email_address:" + customer_email
        end

      end

    rescue => exception
      
      response_code = 500
      puts "There is an exception when call shopify create customer api, email_address: " + customer_email + " message: " + exception.message

    end
      
    {response_code: response_code, message: message}
    
  end
  
  def create_shopify_order(subscription_code, customer_id, email, variant_id, first_name, last_name, address1, address2, phone, city, province, country, zip, billing_first_name, billing_last_name, billing_address1, billing_address2, billing_phone, billing_city, billing_province, billing_country, billing_zip)
    
    require 'net/http'
    
    response_code = 0
    message = ""

    begin

      uri = URI(Rails.configuration.shopify_url + 'admin/orders.json')
      
      Net::HTTP.start(uri.host, uri.port,
        :use_ssl => uri.scheme == 'https') do |http|
        request = Net::HTTP::Post.new uri
        request.basic_auth(Rails.configuration.shopify_apikey,Rails.configuration.shopify_password)

        request.add_field('Content-Type', 'application/json')
        request.body = {
          order: {
            email: email,
            #fulfillment_status: "fulfilled",
            send_receipt: true,
            #send_fulfillment_receipt: true,
            line_items: [
              {
                variant_id: variant_id,
                quantity: 1
              }
            ],
            customer: {
              first_name: first_name,
              last_name: last_name,
              email: email
            },
            billing_address: {
              first_name: billing_first_name,
              last_name: billing_last_name,
              address1: billing_address1,
              address2: billing_address2,
              phone: billing_phone,
              city: billing_city,
              province: billing_province,
              country: billing_country,
              zip: billing_zip
            },
            shipping_address: {
              first_name: first_name,
              last_name: last_name,
              address1: address1,
              address2: address2,
              phone: phone,
              city: city,
              province: province,
              country: country,
              zip: zip
            },
            currency: "USD",
            note: "Recurly Subscription ID: " + subscription_code.to_s + " Account Code: " + customer_id.to_s
          }
        }.to_json
        
        response = http.request(request)
        response_code = Integer(response.code)
        
        if (response.code == "201")
            
            # puts response.body
            @json = JSON.parse(response.body)
            message = @json["order"]["id"]
            
        else
            puts "Shopify create order api return failure response, response_code: " + response.code + " message: " + response.body + " email_address:" + email + " variant_id:" + variant_id
        end

      end

    rescue => exception
      
      response_code = 500
      puts "There is an exception when call shopify create order api, email_address: " + email + " variant_id:" + variant_id + " message: " + exception.message

    end
    
    {response_code: response_code, message: message}
    
  end
  
  def create_recurly_subscription(customer_id, token_id, plan_code, email_address, product_title, product_description)
    
    response_code = 0
    message = ""

    begin

      #if account does not exist, a NotFound Error will be thrown
      #account = Recurly::Account.find '1'

      #subscription will fail because a plan_code is not set
      # subscription = Recurly::Subscription.create(:account => account)
      
      account = Recurly::Account.find(customer_id)
      account.subscriptions.find_each do |subscription|
        puts "Subscription: #{subscription.inspect}"
      end
      
      subscription = Recurly::Subscription.create(
        :plan_code => plan_code,
        #:plan_code => "monthly-399",
        :account   => {
          :account_code => customer_id,
          :billing_info => {
            :token_id => token_id
          }
        }
        #:customer_notes => "Product Name: " + product_title + " - " + product_description
      )
      
    rescue Recurly::Resource::NotFound => e
      
      response_code = 404
      message = e.message
      puts "Recurly create subscription api return failure response, response_code: 404 message: " + e.message + " customer_id:" + customer_id + " email_address:" + email_address + " plan_code:" + plan_code
      
    rescue Recurly::API::UnprocessableEntity => e
      
      response_code = 500
      message = e.message
      puts "Recurly create subscription api return failure response, response_code: 500 message: " + e.message + " customer_id:" + customer_id + " email_address:" + email_address + " plan_code:" + plan_code
      
    else
      
      if subscription.errors && subscription.errors["base"] && !subscription.errors["base"].blank?
          response_code = 999
          message = subscription.errors["base"]
          puts subscription
      else
          response_code = 200
          message = subscription.uuid
      end

    end
      
    {response_code: response_code, message: message}
    
  end
  
  def update_recurly_subscription_note(uuid, order_id, product_title, product_description)
    
    response_code = 0
    message = ""

    begin
      
      subscription = Recurly::Subscription.find(uuid)
      subscription.update_notes(
        customer_notes: "Shopify Order ID: " + order_id.to_s + " Product Name: " + product_title + " - " + product_description
      )
      
      response_code = 200
      message = uuid
      #puts subscription
      
    rescue => exception
      
      response_code = 500
      puts "Recurly update subscription note api return failure response, response_code: 500 message: " + e.message + " uuid:" + uuid

    end
      
    {response_code: response_code, message: message}
    
  end
  
end