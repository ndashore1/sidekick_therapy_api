class CreateGoals < ActiveRecord::Migration[6.1]
  def change
    create_table :goals do |t|
      t.string     :name
      t.boolean    :is_completed
      t.integer    :goal_type
      t.jsonb      :note
      t.references :user, null: false, foreign_key: true
      t.references :plan_of_care, null: false, foreign_key: true

      t.timestamps
    end
  end
end
