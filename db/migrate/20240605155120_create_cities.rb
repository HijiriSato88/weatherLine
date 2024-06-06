class CreateCities < ActiveRecord::Migration[7.1]
  def change
    create_table :cities  do |t|
      t.references :user, foreign_key: true, null: false
      t.string :city_name, null:false
      t.timestamps
    end
  end
end
