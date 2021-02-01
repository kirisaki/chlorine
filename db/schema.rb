# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_31_000000) do

  create_table "containers", charset: "utf8", force: :cascade do |t|
    t.bigint "image_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["image_id"], name: "index_containers_on_image_id"
  end

  create_table "envs", charset: "utf8", force: :cascade do |t|
    t.text "name"
    t.text "value"
    t.bigint "container_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["container_id"], name: "index_envs_on_container_id"
  end

  create_table "images", charset: "utf8", force: :cascade do |t|
    t.text "name"
    t.text "filename"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_images_on_user_id"
  end

  create_table "magicklinks", charset: "utf8", force: :cascade do |t|
    t.text "mail"
    t.text "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "mounts", charset: "utf8", force: :cascade do |t|
    t.text "path"
    t.bigint "volume_id", null: false
    t.bigint "container_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["container_id"], name: "index_mounts_on_container_id"
    t.index ["volume_id"], name: "index_mounts_on_volume_id"
  end

  create_table "users", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.text "mail"
    t.text "fingerprint"
    t.text "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "volumes", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "docker_name"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_volumes_on_user_id"
  end

  add_foreign_key "containers", "images"
  add_foreign_key "envs", "containers"
  add_foreign_key "images", "users"
  add_foreign_key "mounts", "containers"
  add_foreign_key "mounts", "volumes"
  add_foreign_key "volumes", "users"
end
