require 'rails_helper'

RSpec.describe Experience, type: :model do
  let(:candidate) { create(:candidate, uid: 2333) }
  let(:experience) { create(:experience, candidate: candidate) }

  describe 'associations' do 
    it { should belong_to(:candidate) }
    it { should belong_to(:company).optional }
  end

  describe 'validations' do 
    it { should validate_presence_of(:uid) }
    it { should validate_uniqueness_of(:uid) }
  end

  describe '.reverse_chronological' do 
    it 'should return educations in descending order' do 
      first_experience = FactoryBot.create(
        :experience, 
        :first_experience,
        candidate_id: candidate.id
       )
      second_experience = FactoryBot.create(
        :experience, 
        :second_experience,
        candidate_id: candidate.id
      )
      third_experience = FactoryBot.create(
        :experience, 
        :third_experience,
        candidate_id: candidate.id
      )
      current_experience = FactoryBot.create(
        :experience, 
        :current_experience,
        candidate_id: candidate.id
      )

      expect(candidate.experiences.reverse_chronological).to eq([
       current_experience, third_experience, second_experience, first_experience
      ])
    end
  end

  describe '#normalized_start_month' do 
    context 'when a start month is present' do 
      it 'returns the start month' do 
        experience = FactoryBot.create(:experience, start_month: 12)
        expect(experience.normalized_start_month).to eq(12)
      end
    end

    context 'when no start month is present' do 
      it 'returns 1' do 
        experience = FactoryBot.create(:experience, start_month: nil)
        expect(experience.normalized_start_month).to eq(1)
      end
    end
  end

  describe '#normalized_end_year' do 
    context 'when an end year is present' do 
      it 'returns the end year' do 
        experience = FactoryBot.create(:experience, end_year: 5)
        expect(experience.normalized_end_year).to eq(5)
      end
    end

    context 'when no end year is present' do 
      it 'returns the current year' do 
        experience = FactoryBot.create(:experience, end_year: nil)
        expect(experience.normalized_end_year).to eq(Date.current.year)
      end
    end
  end

  describe '#normalized_end_month' do
    context 'when an end month is present' do 
      it 'returns the end month' do 
        experience = FactoryBot.create(:experience, end_month: 2)
        expect(experience.normalized_end_month).to eq(2)
      end
    end

    context 'when no end month is present' do
      it 'returns the current month' do 
        experience = FactoryBot.create(:experience, end_month: nil)
        expect(experience.normalized_end_month).to eq(Date.current.month)
      end
    end
  end

  describe '#duration_in_years' do
    context 'when a start year is present' do 
      it 'returns the calculated duration' do 
        experience_with_same_months = FactoryBot.create(
          :experience,
          start_year: 2000,
          start_month: 1,
          end_year: 2020,
          end_month: 1
        )
        experience_with_different_months = FactoryBot.create(
          :experience,
          start_year: 1990,
          start_month: 1,
          end_year: 1995,
          end_month: 12
        )

        expect(experience_with_same_months.duration_in_years).to eq(20)
        expect(experience_with_different_months.duration_in_years).to be_between(5, 6).exclusive
        
      end
    end

    context 'when no start year is present' do 
      it 'returns 0' do 
        experience = FactoryBot.create(:experience, start_year: nil)
        expect(experience.duration_in_years).to eq(0)
      end
    end
  end

  describe '#start_date' do
    context 'when a start month is present' do
      it 'returns the start date' do 
        experience = FactoryBot.create(
          :experience,
          start_year: 2000,
          start_month: 1,
        )

        expect(experience.start_date).to eq('January 2000')
      end
    end

    context 'when no start month is present' do 
      it 'returns the start year' do 
        experience_with_start_year = FactoryBot.create(
          :experience,
          start_month: nil,
          start_year: 2002
        )

        experience_with_nil_start_year = FactoryBot.create(
          :experience,
          start_month: nil,
          start_year: nil
        )

        expect(experience_with_start_year.start_date).to eq(2002)
        expect(experience_with_nil_start_year.start_date).to eq(nil)
      end
    end
  end

  describe '#end_date' do 
    context 'when an end month is present' do
      it 'returns the end date' do 
        experience = FactoryBot.create(
          :experience,
          end_year: 2000,
          end_month: 1,
        )

        expect(experience.end_date).to eq('January 2000')
      end
    end

    context 'when no end month is present' do 
      context 'when an end year is present' do 
        it 'returns the end year' do 
          experience = FactoryBot.create(
            :experience,
            end_year: 2020,
            end_month: nil,
          )

          expect(experience.end_date).to eq(2020)
        end
      end

      context 'when an end year is not present' do 
        it 'returns "Present"' do 
          experience = FactoryBot.create(
            :experience,
            end_year: nil,
            end_month: nil,
          )

          expect(experience.end_date).to eq("Present")
        end
      end
    end
  end

  describe '#date' do 
    it 'returns the start date - end date' do 
      full_date_experience = FactoryBot.create(
        :experience,
        start_year: 1991,
        start_month: 6,
        end_year: 2001,
        end_month: 12
      )

      only_year_end_start_end = FactoryBot.create(
        :experience,
        start_year: 2022,
        start_month: nil,
        end_year: 2023,
        end_month: nil
      )

      expect(full_date_experience.date).to eq("June 1991 - December 2001")
      expect(only_year_end_start_end.date).to eq('2022 - 2023')
    end
  end
end
