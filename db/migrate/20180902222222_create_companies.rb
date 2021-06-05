class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies, id: :uuid do |t|
      t.string :name
      t.string :nick
      t.string :vat_number
      t.string :address_one
      t.string :address_two
      t.string :city
      t.string :zip_code
      t.string :state
      t.string :country, default: 'ES'
      t.string :email
      t.string :website
      t.string :phone
      t.string :admin_name
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :companies, :nick, unique: true
    add_index :companies, :vat_number, unique: true
  end
end
