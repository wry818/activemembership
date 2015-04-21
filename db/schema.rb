# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150407043136) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "book_codes", force: true do |t|
    t.string   "code"
    t.integer  "shopify_order_id"
    t.integer  "shopify_product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shopify_line_item_id"
    t.boolean  "is_saved_to_shopify"
  end

  create_table "digital_codes", force: true do |t|
    t.string   "code"
    t.integer  "shopify_order_id"
    t.integer  "shopify_product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shopify_line_item_id"
    t.boolean  "is_saved_to_shopify"
  end

end
