class AddLatitudeAndLongitudeToCandidates < ActiveRecord::Migration[6.0]
  def change
    add_column :candidates, :latitude, :float
    add_column :candidates, :longitude, :float
  end
end
