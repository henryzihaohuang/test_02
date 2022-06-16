class Candidate < ApplicationRecord
  geocoded_by :location

  searchkick mappings: {
               dynamic: false,
               properties: {
                 tier1: {
                   type: "text"
                 },
                 tier2: {
                   type: "text"
                 },
                 tier3: {
                   type: "text"
                 },
                 titles: {
                   type: "keyword",
                   eager_global_ordinals: true,
                   fields: {
                     analyzed: {
                       type: "text"
                     }
                   }
                 },
                 company_names: {
                   type: "keyword",
                   eager_global_ordinals: true,
                   fields: {
                     analyzed: {
                       type: "text"
                     }
                   }
                 },
                 school_names: {
                   type: "keyword",
                   eager_global_ordinals: true,
                   fields: {
                     analyzed: {
                       type: "text"
                     }
                   }
                 },
                 degrees: {
                   type: "keyword",
                   eager_global_ordinals: true,
                   fields: {
                     analyzed: {
                       type: "text"
                     }
                   }
                 },
                 industry: {
                   type: "keyword",
                   eager_global_ordinals: true
                 },
                 location: {
                   type: "geo_point"
                 },
                 gender_diverse: {
                   type: "boolean"
                 },
                 open_to_opportunities: {
                   type: "boolean"
                 },
                 ethnically_diverse: {
                   type: "boolean"
                 },
                 veteran: {
                   type: "boolean"
                 },
                 student: {
                   type: "boolean"
                 },
                 has_disability: {
                   type: "boolean"
                 },
                 years_of_experience: {
                   type: "keyword",
                   eager_global_ordinals: true
                 },
                 current_company_headcount: {
                   type: "keyword",
                   eager_global_ordinals: true
                 },
                 full_text: {
                   type: "text"
                 }
               }
             },
             callbacks: :queue,
             settings: {
               number_of_shards: 12,
               number_of_replicas: 0
             }

  enum ethnicity_guess: [:cannot_determine, :asian, :black, :hispanic]

  validates :uid, presence: true,
                  uniqueness: true

  after_validation :geocode

  scope :search_import, -> { includes(:experiences, :educations) }

  has_many :experiences, dependent: :destroy
  has_many :educations, dependent: :destroy
  # TODO: Create a foreign key where deleting a candidate automatically deletes saved candidates
  has_many :saved_candidates, dependent: :destroy

  def first_name
    self.full_name.split(' ').first
  end

  def last_name
    self.full_name.split(' ').last
  end

  def current_experience
    self.experiences.reverse_chronological.first
  end

  def current_title
    self.current_experience&.title
  end

  def current_company
    self.current_experience&.company
  end

  def current_company_name
    self.current_experience&.company_name
  end

  def current_description
    self.current_experience&.description
  end

  def current_company_linked_in_url
    self.current_experience&.company_linked_in_url
  end

  def titles
    self.experiences.reverse_chronological.collect(&:title).uniq.compact
  end

  def company_names
    self.experiences.reverse_chronological.collect(&:company_name).uniq.compact
  end

  def school_names
    self.educations.reverse_chronological.collect(&:school_name).uniq.compact
  end

  def degrees
    self.educations.reverse_chronological.collect(&:degree).uniq.compact
  end

  def years_of_experience
    years_of_experience = self.experiences.sum(&:duration_in_years)
  
    if years_of_experience.between?(1, 2)
      "1-2"
    elsif years_of_experience.between?(3, 5)
      "3-5"
    elsif years_of_experience.between?(6, 10)
      "6-10"
    elsif years_of_experience.between?(11, 15)
      "11-15"
    elsif years_of_experience > 15
      "16+"
    end
  end

  def open_to_opportunities?
    return false if self.experiences.empty?
    
    most_recent_start_year = self&.current_experience&.start_year
    most_recent_end_year = self&.current_experience&.end_year.nil? ? Time.now.year : self.experiences.first.end_year

    return false if most_recent_start_year.nil?
    (most_recent_end_year - most_recent_start_year) >= 3
  end

  def veteran?
    keywords = ["United States Military Academy", "United States Naval Academy", "United States Air Force Academy", "United States Coast Guard Academy", "United States Merchant Marine Academy", "DD214", "MOS", "Rank", "Time In Service", "Duty Station", "Enlisted", "Commissioned"]
    
    keywords.any? {|keyword| self.full_text.downcase.match?(/\b#{keyword.downcase}\b/) }
  end

  def has_disability?
    keywords = ["intellectual disability", "cognitive disability", "developmental disability", "blind", "visually impaired", "disability", "deaf", "hard of hearing", "multiple sclerosis", "cerebral palsy", "epilepsy", "seizure disorder", "wheelchair", "muscular dystrophy", "physical disability", "unable to speak", "synthetic speech", "psychiatric disability", "substance abuse disorder", "neurodiverse", "adhd", "add", "autistic", "autism", "diabetes"]

    keywords.any? {|keyword| self.full_text.downcase.match?(/\b#{keyword.downcase}\b/) }
  end

  def student?
    self.educations.reverse_chronological.first ? !self.educations.reverse_chronological.first.completed? : false
  end

  def full_text
    [self.experiences.reverse_chronological.collect {|experience| [experience.title, experience.company_name, experience.description].compact }, self.bio, self.educations.reverse_chronological.collect {|education| [education.school_name, education.degree, education.description, education.activities_and_societies].compact }].compact.flatten.join(" ")
  end

  def search_data
    {
      tier1: [self.current_title, self.current_company_name, self.current_description].compact,
      tier2: [self.experiences.reverse_chronological.collect {|experience| [experience.title, experience.company_name, experience.description].compact }],
      tier3: [self.bio, self.educations.reverse_chronological.collect {|education| [education.school_name, education.degree, education.description, education.activities_and_societies].compact }].compact,
      titles: self.titles,
      company_names: self.company_names,
      school_names: self.school_names,
      degrees: self.degrees,
      industry: self.industry,
      location: (self.latitude && self.longitude) ? {
        lat: self.latitude,
        lon: self.longitude
      } : nil,
      gender_diverse: self.sex_guess == 'F' ? true : false,
      ethnically_diverse: self.ethnicity_guess == 'cannot_determine' ? false : true,
      years_of_experience: self.years_of_experience,
      open_to_opportunities: self.open_to_opportunities?,
      veteran: self.veteran?,
      student: self.student?,
      has_disability: self.has_disability?,
      current_company_headcount: self.current_company&.headcount,
      full_text: self.full_text
    }
  end

  def get_email
    if self.email
      self.email
    else
      candidate_email = 'N/A'

      personal_email = lookup_personal_email
      if personal_email.present?
        candidate_email = personal_email
      else
        professional_email = lookup_professional_email
        if professional_email.present?
          candidate_email = professional_email
        end
      end

      self.update_column(:email, candidate_email)

      candidate_email
    end

  end

  def lookup_personal_email
    begin
      response = HTTParty.get("https://interseller.io/api/emails/query?version=2", {
        headers: {
          'X-API-Key': ENV['INTERSELLER_API_KEY']
        },
        body: {
          linkedin_url: self.linked_in_url
        }
      })

      json = JSON.parse(response.body)
      if json['emails'] && json['emails'].first
        json['emails'].first
      else
        nil
      end
    rescue => exception
      puts "Exception #{exception}"

      nil
    end
  end

  def lookup_professional_email
    begin
      response = HTTParty.get("https://interseller.io/api/emails/lookup", {
        headers: {
          'X-API-Key': ENV['INTERSELLER_API_KEY']
        },
        body: {
          name: self.full_name,
          query: current_company_name
        }
      })

      json = JSON.parse(response.body)
      if json[0] && json[0]["email"]
        json[0]["email"]
      else
        nil
      end
    rescue => exception
      puts "Exception #{exception}"

      nil
    end
  end
end
