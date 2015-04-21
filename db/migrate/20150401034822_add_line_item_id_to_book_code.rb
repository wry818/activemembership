class AddLineItemIdToBookCode < ActiveRecord::Migration
  def change
    add_column :book_codes, :shopify_line_item_id, :integer
  end
end
