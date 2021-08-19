class CreatePatientHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :patient_histories do |t|
      t.string     :comments
      t.references :patient, null: false, foreign_key: { to_table: :users }
      t.references :plan_of_care, null: false, foreign_key: true
      t.references :old_therapists, foreign_key: { to_table: :users }
      t.references :new_therapists, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
