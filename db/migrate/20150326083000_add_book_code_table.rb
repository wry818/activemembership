class AddBookCodeTable < ActiveRecord::Migration
  def change
    create_table :book_codes do |t|
        t.string :code
        t.integer :shopify_order_id
        t.integer :shopify_product_id
        
        t.timestamps
    end
  end
end
