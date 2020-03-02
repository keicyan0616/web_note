class CreateGoalsets < ActiveRecord::Migration[5.1]
  def change
    create_table :goalsets do |t|
      t.references :user, foreign_key: true
      t.string :mission
      t.string :short_goal
      t.datetime :s_goal_deadline_at
      t.string :middle_goal
      t.datetime :m_goal_deadline_at
      t.string :long_goal
      t.datetime :l_goal_deadline_at
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
