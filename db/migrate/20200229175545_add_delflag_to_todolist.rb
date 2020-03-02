class AddDelflagToTodolist < ActiveRecord::Migration[5.1]
  def change
    add_column :todolists, :delflag, :integer
  end
end
