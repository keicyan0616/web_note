class AddMissionSetAtToGoalset < ActiveRecord::Migration[5.1]
  def change
    add_column :goalsets, :mission_set_at, :datetime
    add_column :goalsets, :s_goal_set_at, :datetime
    add_column :goalsets, :m_goal_set_at, :datetime
    add_column :goalsets, :l_goal_set_at, :datetime
  end
end
