class AddIsSavedToShopifyToDigitalCodes < ActiveRecord::Migration
  def change
    add_column :digital_codes, :is_saved_to_shopify, :boolean
  end
end
