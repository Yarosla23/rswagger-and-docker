class CreateSchoolClasses < ActiveRecord::Migration[8.0]
  def change
    create_table :school_classes do |t|
      t.integer :number
      t.string :letter
      t.references :school, null: false, foreign_key: true
      t.integer :students_count

      t.timestamps
    end
  end
end
