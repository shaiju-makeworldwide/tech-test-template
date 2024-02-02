class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.belongs_to :nationality
      t.string :name, null: false
      t.string :email, null: false, index: { unique: true }
      t.timestamps
    end
  end
end
