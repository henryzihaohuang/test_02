require 'rails_helper'

RSpec.describe Education, type: :model do
  let(:education) { FactoryBot.create(:education)}
  let(:education_without_dates) { FactoryBot.build(:education, :without_dates)}
  let(:has_graduated_education) { FactoryBot.create(:education, :has_graduated) } 
  let(:current_student_education) { FactoryBot.create(:education, :current_student) }

  describe 'associations' do 
    it { should belong_to(:candidate) }
  end

  describe 'validations' do 
    it { should validate_presence_of(:uid) }
    it { should validate_uniqueness_of(:uid) }
  end

  describe '.reverse_chronological' do 
    let(:candidate) { FactoryBot.create(:candidate, full_name: 'John Doe') }
    
    it 'should return educations in descending order' do 
      first_education = FactoryBot.create(
        :education, 
        :first_education,
        candidate_id: candidate.id
      )
      second_education = FactoryBot.create(
        :education, 
        :second_education,
        candidate_id: candidate.id
      )
      third_education = FactoryBot.create(
        :education, 
        :third_education,
        candidate_id: candidate.id
      )
      current_education =  FactoryBot.create(
        :education, 
        :current_education,
        candidate_id: candidate.id
      )
      expect(candidate.educations.reverse_chronological).to eq([
        current_education,
        third_education,
        second_education,
        first_education
      ])
    end
  end

  describe "#completed?" do 
    context 'when the end year & end month are in the past' do 
      subject { has_graduated_education.completed? }
      
      it { is_expected.to eq(true) }
    end

    context 'when the start year & end year are nil' do 
      subject { education_without_dates.completed? }

      it { is_expected.to eq(true) }
    end

    context 'when the start year exists & end year is nil' do 
      let(:education) { FactoryBot.build(:education, :without_dates, end_year: nil)}
      
      it 'should return true' do 
        expect(education.completed?).to eq(true)
      end
    end
    
    context 'when the end year and end month are in the future' do 
      subject { current_student_education.completed? }

      it { is_expected.to eq(false)}
    end
  end

  describe '#start_date' do 
    context 'with a start month' do 
      let(:education) { FactoryBot.build(:education, start_month: '04', start_year: '1991') }
    
      it 'should return the start month and start year' do 
        expect(education.start_date).to eq('April 1991')
      end

      it 'should change the numerical month value to the month name' do 
        expect(education.start_date).to include('April')
      end
    end

    context 'without a start month' do 
      let(:education) { FactoryBot.build(:education, start_month: nil) }
    
      it 'should only return the start year' do 
        expect(education.start_date).to eq(1991)
      end
    end
  end

  describe '#end_date' do 
    context 'with an end month' do 
      let(:education) {FactoryBot.build(:education, end_month: '06', end_year: '1998') }
      
      it 'should return the end month and end year' do 
        expect(education.end_date).to eq('June 1998')
      end

      it 'should change the numerical month value to the month name' do 
        expect(education.end_date).to include('June')
      end
    end

    context 'without an end month' do 
      let(:education) { FactoryBot.build(:education, end_month: nil, end_year: '1998') }

      it 'should only return the end year' do 
        expect(education.end_date).to eq(1998)
      end
    end

    context 'without an end month and end year' do 
      let (:education) { FactoryBot.build(:education, end_month: nil, end_year: nil)}

      subject { education.end_date }
    
      it { is_expected.to eq('Present')}
    end
  end

  describe '#date' do 
    it 'returns the start and end date' do 
      expect(education.date).to eq('April 1991 - June 1995')
    end
  end
end
