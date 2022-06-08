class Company < ApplicationRecord
  geocoded_by :location

  validates :uid, presence: true,
                  uniqueness: true

  after_validation :geocode

  def headcount
    if self.employees_count
      if self.employees_count.between?(1, 10)
        "1-10"
      elsif self.employees_count.between?(11, 50)
        "11-50"
      elsif self.employees_count.between?(51, 200)
        "51-200"
      elsif self.employees_count.between?(201, 500)
        "201-500"
      elsif self.employees_count.between?(501, 1000)
        "501-1000"
      elsif self.employees_count.between?(1001, 5000)
        "1001-5000"
      elsif self.employees_count > 5000
        "5000+"
      end
    else
      nil
    end
  end
end
