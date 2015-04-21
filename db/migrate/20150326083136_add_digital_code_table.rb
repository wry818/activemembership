class AddDigitalCodeTable < ActiveRecord::Migration
  def change
    create_table :digital_codes do |t|
        t.string :code
        t.integer :shopify_order_id
        t.integer :shopify_product_id
        
        t.timestamps
    end
  end
end
