class AdminMailer < ActionMailer::Base

  default from: "Fundraising <fundraising@raisy.entertainment.com>"

  def failure_membership_notification(customer_name, customer_email, order_id, product_id, product_title, reason)
      @customer_name = customer_name
      @customer_email = customer_email
      @order_id = order_id
      @product_id = product_id
      @product_title = product_title
      @reason = reason
      mail to: Rails.configuration.admin_email, subject: "Failure-Shopify Membership Activation"
  end
  
end
