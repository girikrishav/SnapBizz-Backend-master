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

ActiveRecord::Schema.define(version: 20140412225951) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_updates", force: true do |t|
    t.float    "version_number"
    t.string   "appname"
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authentications", force: true do |t|
    t.string   "access_token"
    t.integer  "device_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["device_id"], name: "index_authentications_on_device_id", using: :btree

  create_table "brand_products", force: true do |t|
    t.integer  "brand_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "brand_products", ["brand_id"], name: "index_brand_products_on_brand_id", using: :btree
  add_index "brand_products", ["product_id"], name: "index_brand_products_on_product_id", using: :btree

  create_table "brands", force: true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.string   "store_id"
    t.integer  "tablet_db_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "brands", ["company_id"], name: "index_brands_on_company_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", force: true do |t|
    t.string   "name"
    t.string   "store_id"
    t.integer  "tablet_db_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "company_products", force: true do |t|
    t.integer  "company_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_transaction_products", force: true do |t|
    t.string   "store_id"
    t.integer  "quantity"
    t.float    "sale_price"
    t.integer  "customer_transaction_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "date"
    t.float    "line_item_total"
    t.float    "line_item_profit"
    t.string   "bill_product_unit_type"
  end

  add_index "customer_transaction_products", ["customer_transaction_id"], name: "index_customer_transaction_products_on_customer_transaction_id", using: :btree
  add_index "customer_transaction_products", ["product_id"], name: "index_customer_transaction_products_on_product_id", using: :btree

  create_table "customer_transactions", force: true do |t|
    t.datetime "date"
    t.string   "store_id"
    t.integer  "customer_id"
    t.float    "discount",     default: 0.0
    t.float    "total_amount", default: 0.0
    t.string   "payment_mode", default: "cash"
    t.string   "status",       default: "paid"
    t.integer  "tablet_db_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customer_transactions", ["customer_id"], name: "index_customer_transactions_on_customer_id", using: :btree

  create_table "customers", force: true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "store_id"
    t.integer  "tablet_db_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "devices", force: true do |t|
    t.string   "device_id"
    t.string   "api_key"
    t.string   "access_token"
    t.integer  "store_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "devices", ["store_id"], name: "index_devices_on_store_id", using: :btree

  create_table "distributor_brands", force: true do |t|
    t.integer  "distributor_id"
    t.integer  "brand_id"
    t.string   "store_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "distributor_brands", ["brand_id"], name: "index_distributor_brands_on_brand_id", using: :btree
  add_index "distributor_brands", ["distributor_id"], name: "index_distributor_brands_on_distributor_id", using: :btree

  create_table "distributor_products", force: true do |t|
    t.integer  "distributor_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "distributor_products", ["distributor_id"], name: "index_distributor_products_on_distributor_id", using: :btree
  add_index "distributor_products", ["product_id"], name: "index_distributor_products_on_product_id", using: :btree

  create_table "distributors", force: true do |t|
    t.string   "agency_name"
    t.string   "salesman_name"
    t.string   "phone"
    t.string   "tin"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "store_id"
    t.integer  "tablet_db_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inventories", force: true do |t|
    t.string   "store_id"
    t.string   "barcode"
    t.float    "mrp"
    t.integer  "in_stock_quantity"
    t.float    "purchase_price"
    t.float    "sale_price"
    t.float    "tax_rate"
    t.string   "unit_type"
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.boolean  "is_offer"
  end

  create_table "payments", force: true do |t|
    t.integer  "tablet_db_id"
    t.float    "amount"
    t.integer  "distributor_id"
    t.datetime "payment_date"
    t.string   "mode_of_payment"
    t.string   "cheque_number"
    t.string   "store_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_receive_batch_lists", force: true do |t|
    t.string   "barcode"
    t.string   "store_id"
    t.integer  "quantity"
    t.integer  "available_quantity"
    t.float    "mrp"
    t.float    "purchase_price"
    t.float    "discount"
    t.datetime "date"
    t.integer  "purchase_order_id"
    t.integer  "tablet_db_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.string   "name"
    t.string   "barcode"
    t.float    "mrp"
    t.float    "base_quantity"
    t.string   "unit_type"
    t.string   "store_id"
    t.integer  "brand_id"
    t.integer  "sub_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
  end

  add_index "products", ["brand_id"], name: "index_products_on_brand_id", using: :btree
  add_index "products", ["sub_category_id"], name: "index_products_on_sub_category_id", using: :btree

  create_table "purchase_order_products", force: true do |t|
    t.integer  "purchase_order_id"
    t.integer  "product_id"
    t.string   "store_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "purchase_order_products", ["product_id"], name: "index_purchase_order_products_on_product_id", using: :btree
  add_index "purchase_order_products", ["purchase_order_id"], name: "index_purchase_order_products_on_purchase_order_id", using: :btree

  create_table "purchase_orders", force: true do |t|
    t.integer  "distributor_id"
    t.string   "store_id"
    t.integer  "tablet_db_id"
    t.float    "bill_amount"
    t.string   "status"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "purchase_orders", ["distributor_id"], name: "index_purchase_orders_on_distributor_id", using: :btree

  create_table "push_offers", force: true do |t|
    t.string   "store_id"
    t.string   "purchase_type"
    t.string   "offer_type"
    t.string   "offer_value"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "retailers", force: true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "store_backups", force: true do |t|
    t.string   "store_id"
    t.string   "table"
    t.json     "raw_data"
    t.datetime "sync_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "store_distributors", force: true do |t|
    t.string   "store_id"
    t.integer  "distributor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "store_distributors", ["distributor_id"], name: "index_store_distributors_on_distributor_id", using: :btree

  create_table "stores", force: true do |t|
    t.string   "name"
    t.string   "tin"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.integer  "retailer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stores", ["retailer_id"], name: "index_stores_on_retailer_id", using: :btree

end
