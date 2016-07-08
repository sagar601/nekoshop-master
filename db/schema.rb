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

ActiveRecord::Schema.define(version: 20151220173807) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cart_items", force: :cascade do |t|
    t.integer  "cart_id",                    null: false
    t.integer  "virtual_cat_id",             null: false
    t.integer  "quantity",       default: 0, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "cart_items", ["cart_id"], name: "index_cart_items_on_cart_id", using: :btree
  add_index "cart_items", ["virtual_cat_id"], name: "index_cart_items_on_virtual_cat_id", using: :btree

  create_table "carts", force: :cascade do |t|
    t.integer  "customer_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "carts", ["customer_id"], name: "index_carts_on_customer_id", using: :btree

  create_table "cat_photos", force: :cascade do |t|
    t.integer  "cat_id",                     null: false
    t.boolean  "headshot",   default: false, null: false
    t.string   "image_uid"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "cat_photos", ["cat_id"], name: "index_cat_photos_on_cat_id", using: :btree
  add_index "cat_photos", ["headshot"], name: "index_cat_photos_on_headshot", using: :btree

  create_table "cats", force: :cascade do |t|
    t.string   "name",           limit: 100,                 null: false
    t.string   "species",        limit: 100
    t.string   "summary",        limit: 200
    t.text     "description"
    t.integer  "price_cents",                default: 0,     null: false
    t.string   "price_currency",             default: "EUR", null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "cats", ["name"], name: "index_cats_on_name", unique: true, using: :btree
  add_index "cats", ["species"], name: "index_cats_on_species", using: :btree

  create_table "checkouts", force: :cascade do |t|
    t.integer  "cart_id",                  null: false
    t.integer  "customer_id",              null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.json     "address",     default: {}, null: false
  end

  add_index "checkouts", ["cart_id"], name: "index_checkouts_on_cart_id", using: :btree
  add_index "checkouts", ["customer_id"], name: "index_checkouts_on_customer_id", using: :btree

  create_table "customers", force: :cascade do |t|
    t.integer  "user_id",                  null: false
    t.string   "external_id"
    t.json     "address",     default: {}, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "customers", ["user_id"], name: "index_customers_on_user_id", using: :btree

  create_table "options", force: :cascade do |t|
    t.integer  "cat_id",                  null: false
    t.string   "name",        limit: 100, null: false
    t.text     "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "options", ["cat_id"], name: "index_options_on_cat_id", using: :btree

  create_table "order_items", force: :cascade do |t|
    t.integer  "order_id",                              null: false
    t.string   "name",                                  null: false
    t.string   "variations",            default: [],                 array: true
    t.integer  "quantity",                              null: false
    t.integer  "base_price_cents",      default: 0,     null: false
    t.string   "base_price_currency",   default: "EUR", null: false
    t.integer  "options_cost_cents",    default: 0,     null: false
    t.string   "options_cost_currency", default: "EUR", null: false
    t.integer  "virtual_cat_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "customer_id",                                null: false
    t.string   "charge_id"
    t.string   "state",                  default: "created", null: false
    t.json     "address",                default: {},        null: false
    t.integer  "shipping_cost_cents",    default: 0,         null: false
    t.string   "shipping_cost_currency", default: "EUR",     null: false
    t.integer  "total_cents",            default: 0,         null: false
    t.string   "total_currency",         default: "EUR",     null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "orders", ["customer_id"], name: "index_orders_on_customer_id", using: :btree

  create_table "payment_methods", force: :cascade do |t|
    t.string   "type",        default: "PaymentMethod", null: false
    t.json     "card",        default: {},              null: false
    t.integer  "customer_id"
    t.integer  "checkout_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "payment_methods", ["checkout_id"], name: "index_payment_methods_on_checkout_id", using: :btree
  add_index "payment_methods", ["customer_id"], name: "index_payment_methods_on_customer_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "type",                   default: "User", null: false
    t.string   "name"
    t.string   "email",                  default: "",     null: false
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "variation_photos", force: :cascade do |t|
    t.integer  "variation_id", null: false
    t.string   "image_uid"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "variation_photos", ["variation_id"], name: "index_variation_photos_on_variation_id", using: :btree

  create_table "variations", force: :cascade do |t|
    t.integer  "option_id",                                 null: false
    t.string   "name",          limit: 100,                 null: false
    t.integer  "cost_cents",                default: 0,     null: false
    t.string   "cost_currency",             default: "EUR", null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "variations", ["option_id"], name: "index_variations_on_option_id", using: :btree

  create_table "virtual_cats", force: :cascade do |t|
    t.integer  "cat_id",                  null: false
    t.integer  "stock",      default: 0,  null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "vcid",       default: [],              array: true
  end

  add_index "virtual_cats", ["cat_id"], name: "index_virtual_cats_on_cat_id", using: :btree

  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "virtual_cats"
  add_foreign_key "carts", "customers"
  add_foreign_key "cat_photos", "cats"
  add_foreign_key "checkouts", "carts"
  add_foreign_key "checkouts", "customers"
  add_foreign_key "customers", "users"
  add_foreign_key "options", "cats"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "customers"
  add_foreign_key "payment_methods", "checkouts"
  add_foreign_key "payment_methods", "customers"
  add_foreign_key "variation_photos", "variations"
  add_foreign_key "variations", "options"
  add_foreign_key "virtual_cats", "cats"
end
