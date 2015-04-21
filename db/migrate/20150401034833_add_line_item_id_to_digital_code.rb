class AddLineItemIdToDigitalCode < ActiveRecord::Migration
  def change
    add_column :digital_codes, :shopify_line_item_id, :integer
  end
end
