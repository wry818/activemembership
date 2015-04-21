class AddIsSavedToShopifyToBookCodes < ActiveRecord::Migration
  def change
    add_column :book_codes, :is_saved_to_shopify, :boolean
  end
end
