require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:user_company) { FactoryBot.create(:user) }

  before do 
    # Users (recruiters)
    @recruiter_1 = FactoryBot.create(:user, company_id: user_company.id)
    @recruiter_2 = FactoryBot.create(:user, company_id: user_company.id)

    # Pipelines
    @pipeline_1 = FactoryBot.create(:pipeline, user_id: @recruiter_1.id)
    @pipeline_2 = FactoryBot.create(:pipeline, user_id: @recruiter_2.id)
    FactoryBot.create(:pipeline, user_id: @recruiter_1.id)
    FactoryBot.create(:pipeline, user_id: @recruiter_1.id)

    # Candidates
    valid_candidate_1 = FactoryBot.create(:candidate, email: 'test@email.com')
    valid_candidate_2 = FactoryBot.create(:candidate, email: 'test2@gmail.com')
    valid_candidate_3 = FactoryBot.create(:candidate, email: 'test3@gmail.com')
    candidate_without_email = FactoryBot.create(:candidate, email: nil)

    # Saved Candidates
    FactoryBot.create(
      :saved_candidate,
      pipeline_id: @pipeline_1.id,
      candidate_id: valid_candidate_1.id
    )
    FactoryBot.create(
      :saved_candidate,
      pipeline_id: @pipeline_1.id,
      candidate_id: valid_candidate_2.id
    )
    FactoryBot.create(
      :saved_candidate,
      pipeline_id: @pipeline_1.id,
      candidate_id: candidate_without_email.id
    )
    # non_sourced saved candidate
    FactoryBot.create(
      :saved_candidate,
      pipeline_id: @pipeline_1.id,
      candidate_id: valid_candidate_3.id,
      created_at: Date.today - 5.years
    )
    FactoryBot.create(
      :saved_candidate,
      pipeline_id: @pipeline_2.id,
      candidate_id: valid_candidate_3.id
    )
    FactoryBot.create(
      :saved_candidate,
      pipeline_id: @pipeline_2.id,
      candidate_id: candidate_without_email.id
    )

    # Searches
    FactoryBot.create(
      :search_performed,
      user_id: @recruiter_1.id
    )
    FactoryBot.create(
      :search_performed,
      user_id: @recruiter_1.id
    )

    # App Sessions
    FactoryBot.create(
      :app_session,
      user_id: @recruiter_1.id,
      duration: 100
    )
    FactoryBot.create(
      :app_session,
      user_id: @recruiter_1.id,
      duration: 300
    )
  end

  describe 'associations' do 
    it { should belong_to(:company).optional }
    it { should have_many(:pipelines) }
    it { should have_many(:saved_candidates) }
    it { should have_many(:candidates) }
    it { should have_many(:recruiters) }
    it { should have_many(:app_sessions) }
    it { should have_many(:search_performeds) }
  end

  describe 'validations' do 
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_uniqueness_of(:mogul_id) }
    it { should validate_presence_of(:password) }
  end

  describe '.companies' do 
    it 'returns a list of all users with a company name' do 
      mogul = FactoryBot.create(:user, company_name: 'Mogul')
      nike = FactoryBot.create(:user, company_name: 'Nike')
      apple = FactoryBot.create(:user, company_name: 'Apple')
      FactoryBot.create(:user, company_name: nil)
      microsoft = FactoryBot.create(:user, company_name: 'Microsoft')

      expect(User.companies).to eq([mogul, nike, apple, microsoft])
    end
  end

  describe '#is_company?' do  
    let(:user) { FactoryBot.create(:user) }
    
    context 'when it has recruiters' do 
      it 'returns true' do 
        FactoryBot.create(:user, company_id: user.id)

        expect(user.is_company?).to eq(true)
      end
    end

    context "when it doesn't have recruiters" do 
      it 'returns false' do 
        expect(user.is_company?).to eq(false)
      end
    end
  end

  describe '#is_recruiter?' do 
    context 'when it is not a company' do 
      it 'returns true' do 
        expect(user.is_recruiter?).to eq(true)
      end
    end

    context 'when it is a company' do 
      it 'returns false' do 
        FactoryBot.create(:user, company_id: user.id)
        expect(user.is_recruiter?).to eq(false)
      end
    end
  end

  describe '#number_of_recruiters' do 
    it 'returns the number of recruiters' do 
      FactoryBot.create(:user, company_id: user.id)
      FactoryBot.create(:user, company_id: user.id)
      FactoryBot.create(:user, company_id: user.id)
      FactoryBot.create(:user, company_id: user.id)
      FactoryBot.create(:user, company_id: user.id)

      expect(user.number_of_recruiters).to eq(5)
    end
  end

  describe '#candidates_sourced' do 
    context 'when passed arguments for recruiter_id & date_range' do 
      it "returns the recruiters' total number of sourced candidates created within given date range" do 
        expect(user_company.candidates_sourced(
          Date.yesterday..Date.tomorrow, @recruiter_1.id
        )).to eq(2)

        expect(user_company.candidates_sourced(
          Date.today - 10.years..Date.today - 9.years, @recruiter_1.id
        )).to eq(0)
      end

      it "returns the recruiters' total sourced candidates with an email present" do 
        expect(user_company.candidates_sourced(
          Date.yesterday..Date.tomorrow, @recruiter_2.id
        )).to eq(1)

        expect(user_company.candidates_sourced(
          Date.today - 10.years..Date.today - 9.years, @recruiter_2.id
        )).to eq(0)
      end
    end
  end

  describe '#candidates_saved' do       
    context 'when passed arguments for date_range & recruiter_id' do 
      it "returns the recruiters' total number of saved candidates created within given date range" do 
        expect(user_company.candidates_saved(
          Date.yesterday..Date.tomorrow, @recruiter_1.id
        )).to eq(3)

        expect(user_company.candidates_saved(
          Date.today - 10.years..Date.today - 9.years, @recruiter_1.id
        )).to eq(0)
      end
    end
  end

  describe '#searches_performed' do 
    context 'when passed arguments for date_range & recruiter_id' do 
      it "returns the recruiters' total number of searches performed within given date range" do 
        expect(user_company.searches_performed(
          Date.yesterday..Date.tomorrow, @recruiter_1.id
        )).to eq(2)

        expect(user_company.searches_performed(
          Date.today - 5.years..Date.today - 4.years, @recruiter_1.id
        )).to eq(0)
      end
    end
  end

  describe '#pipelines_saved' do 
    context 'when passed arguments for date_range & recruiter_id' do 
      it "returns the recruiters' total number of pipelines saved within the given date range" do
        expect(user_company.pipelines_saved(
          Date.yesterday..Date.tomorrow, @recruiter_1.id
        )).to eq(3)

        expect(user_company.pipelines_saved(
          Date.today - 5.years..Date.today - 4.years, @recruiter_1.id
        )).to eq(0)
      end
    end
  end

  describe '#time_spent' do 
    context 'when passed arguments for date_range & recruiter_id' do 
      it "returns the recruiters' total duration spent within the given date range" do 
        recruiter_without_duration = FactoryBot.create(:user, company_id: user_company.id)

        expect(user_company.time_spent(
          Date.yesterday..Date.tomorrow, @recruiter_1.id
        )).to eq(400)

        expect(user_company.time_spent(
          Date.today - 5.years..Date.today - 4.years, @recruiter_1.id
        )).to eq(0)

        expect(user_company.time_spent(
          Date.yesterday..Date.tomorrow, recruiter_without_duration.id
        )).to eq(0)
      end
    end
  end
end
