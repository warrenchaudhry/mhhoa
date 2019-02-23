class CreateHomeowners < ActiveRecord::Migration[5.2]
  def change
    create_table :homeowners do |t|
      t.string :firstname
      t.string :mi
      t.string :lastname
      t.references :street, foreign_key: true
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
