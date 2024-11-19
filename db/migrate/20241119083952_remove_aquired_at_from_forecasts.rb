class RemoveAquiredAtFromForecasts < ActiveRecord::Migration[7.1]
  def change
    remove_column :forecasts, :aquired_at, :datetime
  end
end
