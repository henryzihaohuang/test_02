class Experience < ApplicationRecord
  geocoded_by :location

  belongs_to :candidate
  belongs_to :company, optional: true

  validates :uid, presence: true,
                  uniqueness: true

  after_validation :geocode

  scope :reverse_chronological, -> { order('end_year DESC NULLS FIRST, end_month DESC NULLS FIRST, start_year DESC, start_month DESC') }

  def normalized_start_month
    self.start_month || 1
  end

  def normalized_end_year
    end_year ? end_year : Date.current.year
  end

  def normalized_end_month
    end_month ? end_month : Date.current.month
  end

  def duration_in_years
    if self.start_year
      (self.normalized_end_year + (self.normalized_end_month / 12.0)) - (self.start_year + (self.normalized_start_month / 12.0))
    else
      0 # if there's no start year, we can't determine duration
    end
  end

  def start_date
    if start_month
      Date.parse("#{start_month}/#{start_year}").strftime('%B %Y')
    else
      start_year
    end
  end

  def end_date
    if end_month
      Date.parse("#{end_month}/#{end_year}").strftime('%B %Y')
    else
      if end_year
        end_year
      else
        'Present'
      end
    end
  end

  def date
    "#{start_date} - #{end_date}"
  end
end
