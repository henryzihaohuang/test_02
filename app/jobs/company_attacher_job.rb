class CompanyAttacherJob < ApplicationJob
  queue_as :default

  def perform(ids)
    all_experiences = []

    Experience.where(id: ids).find_each do |experience|
      company = Company.where(linked_in_url: experience.company_linked_in_url).first

      if company
        experience.company_id = company.id

        all_experiences << experience.attributes
      end
    end

    begin
      Experience.upsert_all(all_experiences, unique_by: :uid)
    rescue
    end
  end
end
