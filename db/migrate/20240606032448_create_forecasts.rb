class CreateForecasts < ActiveRecord::Migration[7.1]
  def change
    create_table :forecasts do |t|
      t.references :city, foreign_key: true, null: false
      t.float :temp_max,null:false
      t.float :temp_min ,null:false
      t.float :temp_feel ,null:false
      t.float :humidity ,null:false
      t.string :description ,null:false
      t.float :rainfall ,null:false
      t.datetime :date ,null:false
      t.datetime :aquired_at ,null:false
      t.timestamps
    end
  end
end
