class Education < ApplicationRecord
  belongs_to :candidate

  validates :uid, presence: true,
                  uniqueness: true

  scope :reverse_chronological, -> { order('end_year DESC NULLS FIRST, end_month DESC NULLS FIRST, start_year DESC, start_month DESC') }

  def completed?
    if self.start_year.present? && self.end_year.present?
      self.end_year < Date.current.year
    elsif self.start_year.nil? && self.end_year.nil?
      true
    elsif self.start_year.present? && self.end_year.nil?
      true
    elsif self.start_year.nil? && self.end_year.present?
      self.end_year < Date.current.year
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
