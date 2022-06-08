class AddSchoolUrlToEducations < ActiveRecord::Migration[6.1]
  def change
    add_column :educations, :school_url, :string
  end
end
