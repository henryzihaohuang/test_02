class User < ApplicationRecord
  has_secure_password
  has_secure_token :auth_token

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true,
                       on: :create,
                       unless: -> { password_digest.present? }
  validates :mogul_id, uniqueness: true,
                       allow_nil: true

  belongs_to :company, class_name: "User", optional: true

  scope :companies, -> { where.not(company_name: nil) }

  has_many :pipelines, dependent: :destroy
  has_many :saved_candidates, through: :pipelines
  has_many :candidates, through: :saved_candidates
  has_many :recruiters, class_name: "User",
                        foreign_key: "company_id"
  has_many :app_sessions, dependent: :destroy
  has_many :search_performeds

  def is_company?
    self.recruiters.any?
  end

  def is_recruiter?
    !self.is_company?
  end

  def number_of_recruiters
    self.recruiters.count
  end

  def candidates_sourced(date_range, recruiter_id)
    recruiters = self.recruiters
    if recruiter_id
      recruiters = recruiters.where(id: recruiter_id)
    end

    recruiters.sum do |recruiter|
      recruiter.pipelines.sum do |pipeline|
        saved_candidates = pipeline.saved_candidates
        saved_candidates = saved_candidates.joins(:candidate).where.not(candidates: { email: [nil, "N/A"] })
        if date_range
          saved_candidates = saved_candidates.where(created_at: date_range)
        end

        saved_candidates.count
      end
    end
  end

  def candidates_saved(date_range, recruiter_id)
    recruiters = self.recruiters
    if recruiter_id
      recruiters = recruiters.where(id: recruiter_id)
    end

    recruiters.sum do |recruiter|
      recruiter.pipelines.sum do |pipeline|
        saved_candidates = pipeline.saved_candidates

        if date_range
          saved_candidates = saved_candidates.where(created_at: date_range)
        end

        saved_candidates.count
      end
    end
  end

  def searches_performed(date_range, recruiter_id)
    recruiters = self.recruiters
    if recruiter_id
      recruiters = recruiters.where(id: recruiter_id)
    end

    recruiters.sum do |recruiter|
      search_performeds = recruiter.search_performeds

      if date_range
        search_performeds = search_performeds.where(created_at: date_range)
      end

      search_performeds.count
    end
  end

  def pipelines_saved(date_range, recruiter_id)
    recruiters = self.recruiters
    if recruiter_id
      recruiters = recruiters.where(id: recruiter_id)
    end

    recruiters.sum do |recruiter|
      pipelines = recruiter.pipelines

      if date_range
        pipelines = pipelines.where(created_at: date_range)
      end

      pipelines.count
    end
  end

  def time_spent(date_range, recruiter_id)
    recruiters = self.recruiters
    if recruiter_id
      recruiters = recruiters.where(id: recruiter_id)
    end

    recruiters.sum do |recruiter|
      app_sessions = recruiter.app_sessions

      if date_range
        app_sessions = app_sessions.where(created_at: date_range)
      end

      app_sessions.sum do |app_session|
        app_session.duration
      end
    end
  end
end