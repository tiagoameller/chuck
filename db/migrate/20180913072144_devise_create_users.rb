# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: :uuid do |t|
      ## Database authenticatable
      # allow email to be null, yet users can login with company_nick.loginname
      t.string :email #,null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      t.uuid :company_id, foreign_key: true
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :loginname
      t.string :phone
      t.text :comment
      t.boolean :dark_theme, default: false
      t.integer :role, default: 2
      t.boolean :default_admin, default: false
      t.boolean :active, default: true

      t.timestamps null: false
    end

    add_index :users, :reset_password_token,    unique: true
    add_index :users, [:company_id, :username], unique: true
    add_index :users, [:company_id, :email], unique: true
    add_index :users, :loginname, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
    add_index :users, :email, unique: true
  end
end
