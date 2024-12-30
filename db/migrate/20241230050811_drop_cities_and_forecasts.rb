class DropCitiesAndForecasts < ActiveRecord::Migration[7.1]
  def change
    drop_table :forecasts, if_exists: true
    drop_table :cities, if_exists: true
  end
end
