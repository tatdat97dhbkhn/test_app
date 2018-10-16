class CreateLineItems < ActiveRecord::Migration[5.2]
  def change
    create_table :line_items do |t|
      t.string :name
      t.decimal :unit_price
      t.integer :quantity
      t.references :order, foreign_key: true

      t.timestamps
    end
  end
end
