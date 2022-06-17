require 'rails_helper'

RSpec.describe Candidate, type: :model do
  let(:candidate) { create(:candidate, full_name: 'John Doe', uid: 66) }
  let(:candidate_without_experiences) { create(:candidate, full_name: 'test', uid: 60) }
  let(:candidate_without_educations) { create(:candidate, full_name: 'test', uid: 62) }
  
  describe 'associations' do 
    it { should have_many(:educations) }
    it { should have_many(:experiences) }
    it { should have_many(:saved_candidates) }
  end

  describe 'validations' do 
    it { should validate_presence_of(:uid) }
    it { should validate_uniqueness_of(:uid) }
  end

  describe '#first_name' do
    subject { candidate.first_name }

    it { is_expected.to eq('John') }
  end

  describe '#last_name' do 
    subject { candidate.last_name }

    it { is_expected.to eq('Doe') }
  end

  describe 'experience relationship methods' do 
    before do 
      FactoryBot.create(
        :experience, 
        :first_experience,
        candidate_id: candidate.id
      )
      FactoryBot.create(
        :experience, 
        :second_experience,
        description: 'Left due to being visually impaired.',
        candidate_id: candidate.id
      )
      FactoryBot.create(
        :experience, 
        :third_experience,
        description: 'Commissioned',
        candidate_id: candidate.id
      )
      @current_experience = FactoryBot.create(
        :experience, 
        :current_experience,
        candidate_id: candidate.id
      )
    end

    describe '#current_experience' do 
      context 'when they have experiences' do 
        subject { candidate.current_experience }
        it { is_expected.to eq(@current_experience) }
      end

      context "when they don't have experiences" do 
        subject { candidate_without_experiences.current_experience }
        it { is_expected.to eq(nil) }
      end
    end

    describe '#current_title' do 
      context "when they have experiences" do 
        subject { candidate.current_title }
        it { is_expected.to eq('Software Engineer') }
      end

      context "when they don't have experiences" do 
        subject { candidate_without_experiences.current_title }
        it { is_expected.to eq(nil) }
      end
    end

    describe '#current_company_name' do 
      context 'when they have experiences' do 
        subject { candidate.current_company_name }
        it { is_expected.to eq('Mogul') }
      end

      context "when they don't have experiences" do 
        subject { candidate_without_experiences.current_company_name }
        it { is_expected.to eq(nil) }
      end
    end

    describe '#current_description' do 
      context "when they have experiences" do 
        subject { candidate.current_description } 
        it { is_expected.to eq('Making the world a better place')}
      end

      context "when they don't have experiences" do 
        subject { candidate_without_experiences.current_description } 
        it { is_expected.to eq(nil)}
      end
    end

    describe '#current_company_linked_in_url' do 
      context 'when they have experiences' do 
        subject { candidate.current_company_linked_in_url } 
        it { is_expected.to eq('www.linkedin.com/mogul') }
      end

      context "when they don't have experiences" do 
        subject { candidate_without_experiences.current_company_linked_in_url }
        it { is_expected.to eq(nil) }
      end
    end

    describe '#titles' do
      context 'when they have experiences' do 
        subject { candidate.titles }
        it { is_expected.to eq(['Software Engineer', 'Pilot', 'Server']) }
      end

      context "when they don't have experiences" do 
        subject { candidate_without_experiences.titles }
        it { is_expected.to be_empty }
      end
    end

    describe '#company_names' do 
      context "when they have experiences" do 
        subject { candidate.company_names }
        it { is_expected.to eq(['Mogul', 'Delta', 'Olive Garden']) }
      end

      context "when they don't have experiences" do 
        subject { candidate_without_experiences.company_names }
        it { is_expected.to be_empty }
      end
    end

    describe '#years_of_experience' do 
      context 'when they have experiences' do 
        subject { candidate.years_of_experience }
        it { is_expected.to eq('11-15') }
      end

      context "when they don't have experiences" do 
        subject { candidate_without_experiences.years_of_experience }
        it { is_expected.to eq(nil) }
      end
    end

    describe '#open_to_opportunities?' do
      context 'when they have 3+ years of experience in their current job' do
        subject { 
        candidate.open_to_opportunities? 
      }
        it { is_expected.to eq(true) }
      end

      context "when they don't have 3+ years of experience in their current job" do 
        subject { candidate_without_experiences.open_to_opportunities? }
        it { is_expected.to eq(false) }
      end
    end

    describe '#veteran?' do 
      let(:veteran_candidate) { create(:candidate) }
      let(:veteran_candidate_from_bio) { create(:candidate,
        bio: 'I was in the United States Military Academy.'
      )}

      context 'with a veteran keyword in the description of an experience' do 
        subject { candidate.veteran? }
        it { is_expected.to eq(true) }
      end

      context 'with a veteran keyword in an experience title' do 
        before do 
          veteran_title_experience = Experience.create!(uid:1000,
            title: 'Enlisted',
            candidate_id: veteran_candidate.id
          )  
        end
          
        subject { veteran_candidate.veteran? }
        it { is_expected.to eq(true) }
      end

      context 'with a veteran keyword in the company name of an experience' do 
        before do
          veteran_experience = Experience.create!(uid:1001,
            company_name: 'United States Military Academy',
            candidate_id: veteran_candidate.id
          )

                      
        end
        
        subject { veteran_candidate.veteran?}
        it { is_expected.to eq(true) }
      end

      context 'with a veteran keyword in the candidate bio' do 
        subject { veteran_candidate_from_bio.veteran? }
        it { is_expected.to eq(true) }
      end

      context 'with a veteran keyword in the school name of an education' do 
        before do 
          let(:vet_experience5) { create(
            :education, 
            school_name: "United States Air Force Academy",
            candidate_id: veteran_candidate.id)
          }
        end

        subject { veteran_candidate.veteran? }
        it { is_expected.to eq(true) }
      end

      context 'with a veteran keyword in the degree of an education' do 
        before do 
          let(:vet_experience4) { create(
            :education, 
            degree: "DD214",
            candidate_id: veteran_candidate.id)
          }
        end

        subject { veteran_candidate.veteran? }
        it { is_expected.to eq(true) }
      end

      context 'with a veteran keyword in the description of an education' do 
        before do
          let(:vet_experience3) { create(
            :education, 
            description: 'enlisted',
            candidate_id: veteran_candidate.id)
          }
        end
        
        subject { veteran_candidate.veteran? }
        it { is_expected.to eq(true) }
      end

      context 'with a veteran keyword in the activities and societies of an education' do 
        before do
          let(:vet_experience2) { create(
            :education, 
            activities_and_societies: "I was a part of the active duty station",
            candidate_id: veteran_candidate.id)
          }
        end

        subject { veteran_candidate.veteran? }
        it { is_expected.to eq(true) }
      end

      context 'when they are not a veteran' do 
        subject { candidate_without_experiences.veteran? }
        it { is_expected.to eq(false) }
      end
    end

    describe '#has_disability?' do 
      let(:disabled_candidate) { FactoryBot.create(:candidate) }
      let(:disabled_candidate_from_bio) { FactoryBot.create(:candidate, bio: 'neurodiverse student') }
      
      context 'with a disability keyword in the description of an experience' do 
        before do 
          let(:vet_experience) { create(
            :education, 
            activities_and_societies: "I was a part of the active duty station",
            candidate_id: veteran_candidate.id)
          }
          FactoryBot.create(
            :experience,
            description: 'Left due to being visually impaired',
            candidate_id: disabled_candidate.id
          )
        end

        subject { disabled_candidate.has_disability? }
        it { is_expected.to eq(true) }
      end

      context 'with a disability keyword in the title of an experience' do 
        before do 
          FactoryBot.create(
            :experience,
            title: 'Psychiatric Disability',
            candidate_id: disabled_candidate.id
          )
        end

        subject { disabled_candidate.has_disability? }
        it { is_expected.to eq(true) }
      end

      context 'with a disability keyword in the company name of an experience' do 
        before do 
          FactoryBot.create(
            :experience,
            company_name: 'Company of the Visually Impaired',
            candidate_id: disabled_candidate.id
          )
        end

        subject { disabled_candidate.has_disability? }
        it { is_expected.to eq(true) }
      end

      context 'with a disability keyword in the candidate bio' do 
        subject { disabled_candidate_from_bio.has_disability? }
        it { is_expected.to eq(true) }
      end

      context 'with a disability keyword in the school name of an education' do
        before do 
          FactoryBot.create(
            :education, 
            school_name: "School for the Blind",
            candidate_id: disabled_candidate.id
          )
        end

        subject { disabled_candidate.has_disability? }
        it { is_expected.to eq(true) }
      end

      context 'with a disability keyword in the degree of an education' do 
        before do 
          FactoryBot.create(
            :education, 
            degree: 'Intellectual disability studies',
            candidate_id: disabled_candidate.id
          )
        end

        subject { disabled_candidate.has_disability? }
        it { is_expected.to eq(true) }
      end

      context 'with a disability keyword in the description of an education' do 
        before do 
          FactoryBot.create(
            :education, 
            description: 'having wheelchair access in schools is important',
            candidate_id: disabled_candidate.id
           )
        end

        subject { disabled_candidate.has_disability? }
        it { is_expected.to eq(true) }
      end

      context 'with a disability keyword in the activites and societies of an education' do 
        before do 
          FactoryBot.create(
            :education, 
            activities_and_societies: 'was a part of the cognitive disability society',
            candidate_id: disabled_candidate.id
          )
        end

        subject { disabled_candidate.has_disability? }
        it { is_expected.to eq(true) }
      end

      context "when they don't have a disability" do 
        subject { disabled_candidate.has_disability? }
        it { is_expected.to eq(false) }
      end
    end
  end

  describe 'education relationship methods' do
    before do 
      first_school = FactoryBot.create(
        :education,
        school_name: nil,
        start_year: Date.current.year - 20,
        start_month: 1,
        end_year: Date.current.year - 16,
        end_month: 1,
        candidate_id: candidate.id
      )
      second_school = FactoryBot.create(
        :education,
        start_year: Date.current.year - 16,
        start_month: 1,
        end_year: Date.current.year - 12,
        end_month: 1,
        degree: nil,
        school_name: 'Harvard Middle School',
        candidate_id: candidate.id
      )
      third_school = FactoryBot.create(
        :education,
        start_year: Date.current.year - 12,
        start_month: 1,
        end_year: Date.current.year - 8,
        end_month: 1,
        degree: 'Bachelors',
        school_name: 'Harvard High School',
        candidate_id: candidate.id
      )                                        
      current_school = FactoryBot.create(
        :education,
        :current_student,
        school_name: 'Harvard University',
        degree: 'Masters',
        candidate_id: candidate.id
      )
    end

    describe '#school_names' do 
      context 'when they have educations' do 
        subject { candidate.school_names }
        it { is_expected.to eq([
          'Harvard University',
          'Harvard High School',
          'Harvard Middle School'
        ])}
      end

      context "when they don't have educations" do 
        subject { candidate_without_educations.school_names }
        it { is_expected.to be_empty }
      end
    end

    describe '#degrees' do 
      context "when they have educations" do 
        subject { candidate.degrees }
        it { is_expected.to eq(['Masters', 'Bachelors'])}
      end

      context "when they don't have educations" do 
        subject { candidate_without_educations.degrees }
        it { is_expected.to be_empty }
      end
    end

    describe '#student?' do 
      let(:student) { FactoryBot.create(:candidate) }
      let(:non_student) { FactoryBot.create(:candidate) }

      before do
        FactoryBot.create(:education, 
          :current_student,
          candidate_id: student.id
         )
      end

      context 'when they are a student' do 
        subject { student.student? }
        it { is_expected.to eq(true) }
      end

      context 'when they are not a student' do 
        subject { non_student.student? }
        it { is_expected.to eq(false) }
      end
    end
  end

  describe '#full_text' do
    let(:candidate) { FactoryBot.create(:candidate, bio: "Looking for new opportunities") }

    before do 
      FactoryBot.create(
        :experience, 
        :server,
        start_year: 2011,
        end_year: 2011,
        candidate_id: candidate.id
      )
      FactoryBot.create(
        :experience, 
        :pilot,
        start_year: 2012,
        end_year: 2012,
        candidate_id: candidate.id,
        company_name: 'Delta'
      )
      FactoryBot.create(
        :experience,
        :student_intern,
        start_year: 2013,
        end_year: 2013,
        candidate_id: candidate.id,
        company_name: 'Disney'
      )
      FactoryBot.create(
        :experience,
        :software_engineer,
        start_year: 2013,
        end_year: nil,
        candidate_id: candidate.id,
        company_name: 'Mogul',
        description: 'Making the world a better place!'
      )
      FactoryBot.create(
        :education,
        school_name: nil,
        start_year: Date.current.year - 20,
        start_month: 1,
        end_year: Date.current.year - 16,
        end_month: 1,
        candidate_id: candidate.id,
        activities_and_societies: nil,
        description: 'break from school'
      )
      FactoryBot.create(
        :education,
        start_year: Date.current.year - 16,
        start_month: 1,
        end_year: Date.current.year - 12,
        end_month: 1,
        degree: nil,
        school_name: 'Harvard Middle School',
        candidate_id: candidate.id,
        activities_and_societies: nil,
        description: nil
      )
      FactoryBot.create(
        :education,
        start_year: Date.current.year - 12,
        start_month: 1,
        end_year: Date.current.year - 8,
        end_month: 1,
        degree: 'Bachelors',
        school_name: 'Harvard High School',
        candidate_id: candidate.id,
        activities_and_societies: nil,
        description: nil
      )                                        
      FactoryBot.create(
        :education,
        :current_student,
        school_name: 'Harvard University',
        degree: 'Masters',
        candidate_id: candidate.id,
        activities_and_societies: 'SGA President',
        description: 'Studied Physics'
      )
    end
    
    subject { candidate.full_text }
    it { is_expected.to eq(
      'Software Engineer Mogul Making the world a better place!' \
      ' Student Intern Disney Pilot Delta Server Oceans & Ale' \
      ' Looking for new opportunities Harvard University Masters' \
      ' Studied Physics SGA President Harvard High School Bachelors' \
      ' Harvard Middle School Bachelors break from school'
    )}
  end
end
