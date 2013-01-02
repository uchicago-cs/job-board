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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130102025218) do

  create_table "employers", :force => true do |t|
    t.string   "email"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "url"
    t.string   "company"
    t.text     "note_to_reviewer"
    t.boolean  "approved"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "employers", ["email"], :name => "index_employers_on_email", :unique => true
  add_index "employers", ["reset_password_token"], :name => "index_employers_on_reset_password_token", :unique => true

  create_table "postings", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "comments"
    t.integer  "jobtype"
    t.string   "company"
    t.datetime "active_until"
    t.integer  "state"
    t.string   "url"
    t.integer  "employer_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string   "location"
    t.text     "contact"
  end

  create_table "postings_tags", :force => true do |t|
    t.integer "posting_id"
    t.integer "tag_id"
  end

  create_table "students", :force => true do |t|
    t.string   "cnet"
    t.string   "email"
    t.string   "firstname"
    t.string   "lastname"
    t.integer  "role"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "sign_in_count",      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "students", ["email"], :name => "index_students_on_email", :unique => true

  create_table "students_tags", :force => true do |t|
    t.integer "student_id"
    t.integer "tag_id"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
