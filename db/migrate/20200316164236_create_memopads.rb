class CreateMemopads < ActiveRecord::Migration[5.1]
  def change
    create_table :memopads do |t|
      t.references :user, foreign_key: true
      t.string :title
      t.string :memo
      t.integer :orderno
      t.integer :delflag
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
