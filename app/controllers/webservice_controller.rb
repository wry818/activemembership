class WebserviceController < ApplicationController
    # before_filter :load_shopify_order_data, only: [:index, :login]
#
#     def index
#
#     end
#
#     def login
#
#     end
#
#     def ajax_get_shopify_product_type
#
#       require 'net/http'
#
#       @result = ""
#       @order_id = params[:order_id]
#
#       begin
#
#         uri = URI(Rails.configuration.shopify_url + 'admin/products.json?ids=' + params[:ids] + '&fields=id,product_type')
#
#         Net::HTTP.start(uri.host, uri.port,
#           :use_ssl => uri.scheme == 'https') do |http|
#           request = Net::HTTP::Get.new uri
#           request.basic_auth(Rails.configuration.shopify_apikey,Rails.configuration.shopify_password)
#
#           response = http.request(request)
#
#           if (response.code == "200")
#               @json = JSON.parse(response.body)
#               @result = {code: Integer(response.code), products: @json["products"]}.to_json
#           else
#               puts "Shopify products api return failure response, response_code: " + response.code + " message: " + response.body + " order_id:" + @order_id
#               @result = {code: Integer(response.code)}.to_json
#           end
#
#         end
#
#       rescue => exception
#
#         puts "There is an exception when call shopify products api, order_id: " + @order_id + " message: " + exception.message
#         @result = {code: 500, message: exception.message}.to_json
#
#       end
#
#       render json: @result
#
#     end
#
#     def ajax_initialreg
#
#       customer_name = params[:firstName] + " " + params[:lastName]
#       customer_email = params[:eMailAddress]
#       order_id = params[:order_id]
#       products = params[:products]
#
#       has_register_failure = false
#       token = ""
#       response_code = ""
#       response_message = ""
#
#       # title = "aa"
# #       customer_name = "aa"
# #       customer_email = "aa"
# #       order_id = "aa"
# #       response_code = "aa"
# #       product_id = "aa"
# #       message = "aa"
# #
# #       send_notification_email(title, customer_name, customer_email, order_id, response_code, message, product_id)
# #       render text: "aa"
#
#       #initial reg for first product
#       products.each do |product|
#
#         if product[1][:is_first]
#
#           result = call_inital_reg_api(customer_name, customer_email, order_id, params, product[1])
#           response_code = result[:response_code]
#           response_message = result[:message]
#
#           if response_code == 200
#             json = JSON.parse(result[:message])
#             token = json["theToken"]
#           end
#
#           break
#
#         end
#
#       end
#
#  # render json: {response_code: response_code, message: response_message}.to_json
#
#       if token != ""
#
#         #register for rest of products
#         products.each do |product|
#
#           loop_times = Integer(product[1][:quantity])
#
#           if product[1][:is_first] == "true"
#             loop_times = loop_times - 1
#           end
#
#           for i in 1..loop_times
#
#             result = call_register_api(customer_name, customer_email, order_id, token, product[1])
#             response_code = result[:response_code]
#             response_message += result[:message]
#
#             if response_code != 200
#               has_register_failure = true
#             end
#
#           end
#
#         end
#
#         if !has_register_failure
#
#           render json: {code: 200, message: token}.to_json
#
#         else
#
#           render json: {code: 500, message: response_message}.to_json
#
#         end
#
#       else
#
#         if response_message.include? "ClientInputException"
#           render json: {code: 999, message: response_message}.to_json
#         else
#           render json: {code: 500, message: response_message}.to_json
#         end
#
#       end
#
#     end
#
#     def ajax_register
#
#       customer_name = params[:firstName] + " " + params[:lastName]
#       customer_email = params[:eMailAddress]
#       order_id = params[:order_id]
#       products = params[:products]
#
#       has_register_failure = false
#       token = ""
#       response_code = ""
#       response_message = ""
#
#       #get token
#       result = call_login_api(customer_name, customer_email, params[:password], order_id)
#
#       response_code = result[:response_code]
#       response_message = result[:message]
#
#       if response_code == 200
#         json = JSON.parse(result[:message])
#         token = json["theToken"]
#       end
#
#       if token != ""
#
#          products.each do |product|
#
#            for i in 1..Integer(product[1][:quantity])
#
#              result = call_register_api(customer_name, customer_email, order_id, token, product[1])
#              response_code = result[:response_code]
#              response_message += result[:message]
#
#              if response_code != 200
#                has_register_failure = true
#              end
#
#            end
#
#          end
#
#          if !has_register_failure
#
#            render json: {code: 200, message: response_message}.to_json
#
#          else
#
#            render json: {code: 500, message: response_message}.to_json
#
#          end
#
#        else
#
#          render json: {code: 999, message: response_message}.to_json
#
#        end
#
#     end
#
#     private
#
#     def load_shopify_order_data
#
#       require 'net/http'
#
#       @result = ""
#       @order_id = params[:id]
#
#       begin
#
#         uri = URI(Rails.configuration.shopify_url + 'admin/orders/' + @order_id + '.json?fields=customer,line_items')
#
#         Net::HTTP.start(uri.host, uri.port,
#           :use_ssl => uri.scheme == 'https') do |http|
#           request = Net::HTTP::Get.new uri
#           request.basic_auth(Rails.configuration.shopify_apikey,Rails.configuration.shopify_password)
#
#           response = http.request(request)
#
#           if (response.code == "200")
#               @json = JSON.parse(response.body)
#               @result = {code: Integer(response.code), data: @json["order"]}.to_json
#           else
#               puts "Shopify order api return failure response, response_code: " + response.code + " message: " + response.body + " order_id:" + @order_id
#               @result = {code: Integer(response.code)}.to_json
#           end
#
#         end
#
#       rescue => exception
#
#         puts "There is an exception when call shopify order api, order_id: " + @order_id + " message: " + exception.message
#         @result = {code: 500, message: exception.message}.to_json
#
#       end
#
#     end
#
#     def call_inital_reg_api(customer_name, customer_email, order_id, params, product)
#
#       #{response_code: 200, message: "unhandled exception"}
#
#       require 'net/http'
#
#       response_code = 0
#       message = ""
#       product_id = product[:id]
#       product_title = product[:title]
#
#       # title = "Initialreg api return failure response."
# #       message = response.body
# #       send_notification_email(title, customer_name, customer_email, order_id, "response.code", message, product_id)
#
#       begin
#
#         url = URI.parse(Rails.configuration.entertainment_api_url + "/editions/initialreg")
#         http = Net::HTTP.new(url.host, url.port)
#         http.use_ssl = (url.scheme == 'https')
#         if url.scheme == 'https'
#           http.verify_mode = OpenSSL::SSL::VERIFY_NONE
#         end
#
#         request = Net::HTTP::Post.new(url.to_s)
#
#         request['User-Agent'] = Rails.configuration.app_name
#         request.add_field('Content-Type', 'application/json')
#         request.body = {
#                   account:
#                       {
#                           # eMailAddress: "commander2@warhammer.com",
#                           eMailAddress: params[:eMailAddress],
#                           password: params[:password],
#                           firstName: params[:firstName],
#                           lastName: params[:lastName],
#                           addr1: params[:addr1],
#                           city: params[:city],
#                           state: params[:state],
#                           zip: params[:zip],
#                           phone: params[:phone]
#                       },
#                   editionCode: product[:sku],
#                   accessCode: Rails.configuration.access_code,
#                   howAcquired: Rails.configuration.how_acquired
#               }.to_json
#
#         response = http.start {|http|
#           http.request(request)
#         }
#
#         response_code = Integer(response.code)
#
#         if response_code == 200
#
#           message = response.body
#
#         else
#
#           title = "Initialreg api return failure response."
#           message = response.body
#           send_notification_email(title, customer_name, customer_email, order_id, response.code, message, product_id, product_title)
#
#         end
#
#       rescue => exception
#
#         title = "There is an exception when call Initialreg api."
#         response_code = 500
#         message = exception.message
#
#         send_notification_email(title, customer_name, customer_email, order_id, "500", message, product_id, product_title)
#
#       end
#
#       {response_code: response_code, message: message}
#
#     end
#
#     def call_register_api(customer_name, customer_email, order_id, token, product)
#
#       require 'net/http'
#
#       response_code = 0
#       message = ""
#       product_id = product[:id]
#       product_title = product[:title]
#
#       begin
#
#         url = URI.parse(Rails.configuration.entertainment_api_url + "/editions/register")
#         http = Net::HTTP.new(url.host, url.port)
#         http.use_ssl = (url.scheme == 'https')
#         if url.scheme == 'https'
#           http.verify_mode = OpenSSL::SSL::VERIFY_NONE
#         end
#
#         request = Net::HTTP::Post.new(url.to_s)
#
#         puts Rails.configuration.app_name
#         request['User-Agent'] = Rails.configuration.app_name
#         request.add_field('Content-Type', 'application/json')
#         request.body = {
#           theToken: token,
#           editionCode: product[:sku],
#           accessCode: Rails.configuration.access_code,
#           howAcquired: Rails.configuration.how_acquired
#         }.to_json
#
#         response = http.start {|http|
#           http.request(request)
#         }
#
#         response_code = Integer(response.code)
#
#         if response_code != 200
#
#           title = "Register api return failure response."
#           message = response.body
#
#           send_notification_email(title, customer_name, customer_email, order_id, response.code, message, product_id, product_title)
#
#         end
#
#       rescue => exception
#
#         title = "There is an exception when call Register api."
#         response_code = 500
#         message = exception.message
#
#         send_notification_email(title, customer_name, customer_email, order_id, "500", message, product_id, product_title)
#
#       end
#
#       {response_code: response_code, message: message}
#
#     end
#
#     def call_login_api(customer_name, customer_email, password, order_id)
#
#       require 'net/http'
#
#       response_code = 0
#       message = ""
#
#       begin
#
#         url = URI.parse(Rails.configuration.entertainment_api_url + "/accounts/login")
#         http = Net::HTTP.new(url.host, url.port)
#         http.use_ssl = (url.scheme == 'https')
#         if url.scheme == 'https'
#           http.verify_mode = OpenSSL::SSL::VERIFY_NONE
#         end
#
#         request = Net::HTTP::Post.new(url.to_s)
#
#         request['User-Agent'] = Rails.configuration.app_name
#         request.add_field('Content-Type', 'application/json')
#         request.body = {
#           eMailAddress: customer_email,
#           password: password,
#         }.to_json
#
#         response = http.start {|http|
#           http.request(request)
#         }
#
#         response_code = Integer(response.code)
#         message = response.body
#
#         if response_code != 200
#
#           title = "Login api return failure response."
#           send_notification_email(title, customer_name, customer_email, order_id, response.code, message, "", "")
#
#         end
#
#       rescue => exception
#
#         title = "There is an exception when call Login api."
#         response_code = 500
#         message = exception.message
#
#         send_notification_email(title, customer_name, customer_email, order_id, "500", message, "", "")
#
#       end
#
#       {response_code: response_code, message: message}
#
#     end
#
#     def send_notification_email(title, customer_name, customer_email, order_id, response_code, message, product_id, product_title)
#
#       begin
#
#         reason = title + " response_code: " + response_code + " message: " + message
#         puts reason + " customerName: " + customer_name + " customerEmail: " + customer_email + " order_id: " + order_id + " product_id: " + product_id + " product_title: " + product_title
#         AdminMailer.failure_membership_notification(customer_name, customer_email, order_id, product_id, product_title, reason).deliver
#
#       rescue => exception
#
#           puts "There is an exception when send notification email message: " + exception.message + " customerName: " + customer_name + " customerEmail: " + customer_email + " order_id: " + order_id + " product_id: " + product_id + " product_title: " + product_title
#
#       end
#
#     end
    
end
