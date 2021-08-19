class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      # User Personal Information
      t.string  :name,              null: false, default: ""
      t.string  :email,             null: false, default: ""
      t.string  :password_digest
      t.integer :age
      t.integer :gender
      t.integer :user_type, null: false, default: 0
      t.text    :address
      t.string  :phone_number
      t.string  :auth_token

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
