class AddBelongsToCompanyToExperiences < ActiveRecord::Migration[6.1]
  def change
    add_reference :experiences, :company, index: true,
                                          foreign_key: true
  end
end
