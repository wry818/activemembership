class TestController < ApplicationController
  
  def index
    book_code = BookCode.first
    @aa = book_code.code
    
  end
  
  def ajax_initialreg_page

    require 'net/http'
  
    begin
      
      url = URI.parse(params[:url] + "/editions/initialreg")
      request = Net::HTTP::Post.new(url.to_s)

      request.add_field('Content-Type', 'application/json')
      request.body = {
                account:
                    {
                        eMailAddress: params[:eMailAddress],
                        #eMailAddress: "angelknight@warhammer.com",
                        password: params[:password],
                        firstName: "D",
                        lastName: "Buckley",
                        addr1: "123 Test St",
                        city: "Detroit",
                        state: "MI",
                        zip: "48301",
                        phone: "2483923232"
                    },
                editionCode: "15EE0055",
                accessCode: Rails.configuration.access_code,
                howAcquired: Rails.configuration.how_acquired
            }.to_json

      response = Net::HTTP.start(url.host, url.port) {|http|
        http.request(request)
      }

      if response.code == "200"
      
        render text: "Response code: " + response.code + " " + response.body
      
      else
      
        render text: "Response code: " + response.code + " " + response.body
      
      end
    
    rescue => exception
    
      render text: exception.message
    
    end
  
  end
  
  def ajax_login_page

    require 'net/http'
  
    begin

      url = URI.parse(params[:url] + "/accounts/login")
      request = Net::HTTP::Post.new(url.to_s)

      request.add_field('Content-Type', 'application/json')
      request.body = {
        #eMailAddress: "angelknight@warhammer.com",
        eMailAddress: params[:eMailAddress],
        password: params[:password]
      }.to_json

      response = Net::HTTP.start(url.host, url.port) {|http|
        http.request(request)
      }

      if response.code == "200"
      
        render text: "Response code: " + response.code + " " + response.body
      
      else
      
        render text: "Response code: " + response.code + " " + response.body
      
      end
    
    rescue => exception
    
      render text: exception.message
    
    end
  
  end
  
  def ajax_register_page

    require 'net/http'
  
    begin

      url = URI.parse(params[:url] + "/editions/register")
      request = Net::HTTP::Post.new(url.to_s)

      request.add_field('Content-Type', 'application/json')
      request.body = {
        theToken: params[:token],
        editionCode: "15EE0055",
        accessCode: Rails.configuration.access_code,
        howAcquired: Rails.configuration.how_acquired
      }.to_json

      response = Net::HTTP.start(url.host, url.port) {|http|
        http.request(request)
      }

      if response.code == "200"
      
        render text: "Response code: " + response.code + " " + response.body
      
      else
      
        render text: "Response code: " + response.code + " " + response.body
      
      end
    
    rescue => exception
    
      render text: exception.message
    
    end
  
  end
  
  def ajax_login

    require 'net/http'
  
    begin

      url = URI.parse(Rails.configuration.entertainment_api_url + "/accounts/login")
      request = Net::HTTP::Post.new(url.to_s)

      request.add_field('Content-Type', 'application/json')
      request.body = {
        eMailAddress: "commander2@warhammer.com",
        password: "111111",
      }.to_json

      response = Net::HTTP.start(url.host, url.port) {|http|
        http.request(request)
      }

      if response.code == "200"
      
        render text: "Response code: " + response.code + " " + response.body
      
      else
      
        render text: "Response code: " + response.code + " " + response.body
      
      end
    
    rescue => exception
    
      render text: exception.message
    
    end
  
  end
  
  def create_shopify_order
    
    require 'net/http'

    begin

      uri = URI(Rails.configuration.shopify_url + 'admin/orders.json')
      
      Net::HTTP.start(uri.host, uri.port,
        :use_ssl => uri.scheme == 'https') do |http|
        request = Net::HTTP::Post.new uri
        request.basic_auth(Rails.configuration.shopify_apikey,Rails.configuration.shopify_password)

        request.add_field('Content-Type', 'application/json')
        request.body = {
          order: {
            email: "rwen@dowelltech.cn",
            #fulfillment_status: "fulfilled",
            send_receipt: true,
            #send_fulfillment_receipt: true,
            line_items: [
              {
                #variant_id: 1052848075,
                title: "2015 Entertainment Coupon Book",
                price: 19.99,
                grams: 0,
                quantity: 1
              }
            ],
            customer: {
              first_name: "god",
              last_name: "emperor",
              email: "rwen@dowelltech.cn"
            },
            billing_address: {
              first_name: "god",
              last_name: "emperor",
              address1: "123 Fake Street",
              phone: "555-555-5555",
              city: "Fakecity",
              province: "Michigan",
              country: "US",
              zip: "48326"
            },
            shipping_address: {
              first_name: "god",
              last_name: "emperor",
              address1: "123 Fake Street",
              phone: "555-555-5555",
              city: "Fakecity",
              province: "Michigan",
              country: "US",
              zip: "48326"
            }, 
            tax_lines: [
              {
                price: 0.00,
                rate: 0.06,
                title: "MI State Tax"
              }
            ],
            transactions: [
              {
                kind: "sale",
                status: "success",
                amount: 19.99
              }
            ],
            total_tax: 0.00,
            currency: "USD"
          }
        }.to_json
        
        response = http.request(request)

        render text: response.body + " " + response.code

      end

    rescue => exception
      render text: exception.message + " " + "999"
    end
    
  end
  
  def add_metafield_orders
    
    require 'net/http'

    begin

      uri = URI(Rails.configuration.shopify_url + 'admin/orders/300512711.json')
      
      Net::HTTP.start(uri.host, uri.port,
        :use_ssl => uri.scheme == 'https') do |http|
        request = Net::HTTP::Put.new uri
        request.basic_auth(Rails.configuration.shopify_apikey,Rails.configuration.shopify_password)

        request.add_field('Content-Type', 'application/json')
        request.body = {
          order: {
            id: 300512711,
            note_attributes: [
                  {
                    name: "colour",
                    value: "red"
                  },
                  {
                    name: "value",
                    value: "custom value"
                  }
            ]
                
            # metafields: [
#                   {
#                     key: "code1",
#                     value: "12345",
#                     value_type: "string",
#                     namespace: "global"
#                   },
#                   {
#                     key: "code2",
#                     value: "45678",
#                     value_type: "string",
#                     namespace: "global"
#                   }
#             ]

          }
        }.to_json
        
        response = http.request(request)

        render text: response.body + " " + response.code

      end

    rescue => exception
      render text: exception.message + " " + "999"
    end
    
  end
  
  def ajax_login

    require 'net/http'
  
    begin

      url = URI.parse(Rails.configuration.entertainment_api_url + "/accounts/login")
      request = Net::HTTP::Post.new(url.to_s)

      request.add_field('Content-Type', 'application/json')
      request.body = {
        eMailAddress: "commander2@warhammer.com",
        password: "111111",
      }.to_json

      response = Net::HTTP.start(url.host, url.port) {|http|
        http.request(request)
      }

      if response.code == "200"
      
        render text: "Response code: " + response.code + " " + response.body
      
      else
      
        render text: "Response code: " + response.code + " " + response.body
      
      end
    
    rescue => exception
    
      render text: exception.message
    
    end
  
  end

  def ajax_edition

    require 'net/http'
  
    begin

      url = URI.parse(Rails.configuration.entertainment_api_url + "/editions")
      request = Net::HTTP::Post.new(url.to_s)

      request.add_field('Content-Type', 'application/json')
      request.body = {
        #theToken: "RiEvZW9xOaaY0ByABTfQsOaZP1It4DbMI4lGJRS4IqUQetaJ8xYpJexvTChm++cx", #dev
        theToken: "1SO4f0q51XWxq9LMvE4eY/ecmTS10qUGLskYr5sJmBHu4YwuC70iUgFQEldhVd/n",  #uat
      }.to_json

      response = Net::HTTP.start(url.host, url.port) {|http|
        http.request(request)
      }

      if response.code == "200"
      
        render text: response.body
      
      else
      
        render text: "Response code: " + response.code + " " + response.body
      
      end
    
    rescue => exception
    
      render text: exception.message
    
    end
  
  end

  def ajax_register

    require 'net/http'
  
    begin

      url = URI.parse(Rails.configuration.entertainment_api_url + "/editions/register")
      request = Net::HTTP::Post.new(url.to_s)

      request.add_field('Content-Type', 'application/json')
      request.body = {
        #theToken: "RiEvZW9xOaaY0ByABTfQsOaZP1It4DbMI4lGJRS4IqUQetaJ8xYpJexvTChm++cx", #dev
        theToken: "CpNDxJTu1jTUmokIrpddfYmo7pnyXiKBrB9XsPAmZUwFXCdvqFnDMw==",  #uat
        editionCode: "15EE0055",
        accessCode: Rails.configuration.access_code,
        howAcquired: Rails.configuration.how_acquired
      }.to_json

      response = Net::HTTP.start(url.host, url.port) {|http|
        http.request(request)
      }

      if response.code == "200"
      
        render text: response.body
      
      else
      
        render text: "Response code: " + response.code + " " + response.body
      
      end
    
    rescue => exception
    
      render text: exception.message
    
    end
  
  end
  
end