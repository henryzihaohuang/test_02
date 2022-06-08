require 'rails_helper'

RSpec.describe Company, type: :model do
  let(:company) { FactoryBot.create(:company) }
  let(:tech_company) { FactoryBot.build(:company, :tech_company)}


  describe 'validations' do 
    it { should validate_presence_of(:uid) }
    it { should validate_uniqueness_of(:uid) }
  end

  describe '#headcount' do 
    let(:company) { FactoryBot.create(:company, :no_employees) }
    let(:company_with_1_employee) { FactoryBot.create(:company, employees_count: 1 )}
    let(:company_with_10_employees) { FactoryBot.create(:company, employees_count: 10 )}
    let(:company_with_11_employees) { FactoryBot.create(:company, employees_count: 11 )}
    let(:company_with_50_employees) { FactoryBot.create(:company, employees_count: 50 )}
    let(:company_with_51_employees) { FactoryBot.create(:company, employees_count: 51 )}
    let(:company_with_200_employees) { FactoryBot.create(:company, employees_count: 200 )}
    let(:company_with_201_employees) { FactoryBot.create(:company, employees_count: 201 )}
    let(:company_with_500_employees) { FactoryBot.create(:company, employees_count: 500 )}
    let(:company_with_501_employees) { FactoryBot.create(:company, employees_count: 501 )}
    let(:company_with_1000_employees) { FactoryBot.create(:company, employees_count: 1000 )}
    let(:company_with_1001_employees) { FactoryBot.create(:company, employees_count: 1001 )}
    let(:company_with_5000_employees) { FactoryBot.create(:company, employees_count: 5000 )}
    let(:company_with_5001_employees) { FactoryBot.create(:company, employees_count: 5001 )}


    context 'when there are between 1-10 employees' do 
      it 'returns "1-10"' do 
        expect(company_with_1_employee.headcount).to eq('1-10')
        expect(company_with_10_employees.headcount).to eq('1-10')
      end
    end

    context 'when there are between 11-50 employees' do 
      it 'returns "11-50"' do
        expect(company_with_11_employees.headcount).to eq('11-50')
        expect(company_with_50_employees.headcount).to eq('11-50')
      end
    end

    context 'when there are between 51-200 employees' do 
      it 'returns "51-200' do 
        expect(company_with_51_employees.headcount).to eq('51-200')
        expect(company_with_200_employees.headcount).to eq('51-200')
      end
    end

    context 'when there are between 201 and 500 employees' do 
      it 'returns "201-500"' do 
        expect(company_with_201_employees.headcount).to eq('201-500')
        expect(company_with_500_employees.headcount).to eq('201-500')
      end
    end

    context 'when there are between 501 and 1000 employees' do 
      it 'returns "501-1000"' do 
        expect(company_with_501_employees.headcount).to eq("501-1000")
        expect(company_with_1000_employees.headcount).to eq("501-1000")
      end
    end

    context 'when there are between 10001 and 5000 employees' do 
      it 'returns "10001-5000"' do 
        expect(company_with_1001_employees.headcount).to eq("1001-5000")
        expect(company_with_5000_employees.headcount).to eq("1001-5000")
      end
    end

    context 'when there are over 5000 employees' do 
      it 'returns "5000+"' do 
        expect(company_with_5001_employees.headcount).to eq("5000+")
      end
    end

    context 'when there are no employees' do 
      subject { company.headcount }
      it { is_expected.to eq(nil) }
    end
  end
end
