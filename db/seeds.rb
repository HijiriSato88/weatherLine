require "csv"
CSV.foreach('db/csv/city.csv') do |row|
  City.create(
    city_name: row[0],
    city_id: row[1]
  )
end
