class CreateWeatherforecasts < ActiveRecord::Migration[7.1]
  def change
    create_table :weatherforecasts do |t|
      t.references :weathers, foreign_key: true, null: false
      t.float :temp_max,null:false
      t.float :temp_min ,null:false
      t.float :temp_feel ,null:false
      t.integer :weather_id ,null:false
      t.float :rainfall ,null:false
      t.datetime :date ,null:false
      t.datetime :aquired_at ,null:false
      t.timestamps
    end
  end
end
