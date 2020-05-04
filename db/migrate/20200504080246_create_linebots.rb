class CreateLinebots < ActiveRecord::Migration[5.1]
  def change
    create_table :linebots do |t|
      t.references :user, foreign_key: true
      t.string :line_uid
      t.integer :valid_flag
      t.integer :week1_flag
      t.integer :week2_flag
      t.integer :week3_flag
      t.integer :week4_flag
      t.integer :week5_flag
      t.integer :week6_flag
      t.integer :week7_flag
      t.datetime :dotime_at

      t.timestamps
    end
  end
end
