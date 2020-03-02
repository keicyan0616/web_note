class CreateTodolists < ActiveRecord::Migration[5.1]
  def change
    create_table :todolists do |t|
      t.references :user, foreign_key: true
      t.string :todo
      t.datetime :start_date
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
