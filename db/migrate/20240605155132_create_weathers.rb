class CreateWeathers < ActiveRecord::Migration[7.1]
  def change
    create_table :weathers do |t|
      t.references :user, foreign_key: true, null: false
      t.string :forecast, null: false
      t.timestamps
    end
  end
end
