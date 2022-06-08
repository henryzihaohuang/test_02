require 'rails_helper'

# If you haven't already done so, you'll need to seed your test DB:
# https://www.notion.so/mogul-engineering/Onboarding-0a72830bdb7842dfb93b40ee9f2adb05#fa3c6e981fba45e5af4640764fb7bd7b
# rails db:seed RAILS_ENV=test --trace in the console

RSpec.describe Searcher do
  let(:searcher) { Searcher.new }
  server = Experience.find_by_title('Server')&.candidate
  case_manager = Experience.find_by_company_name('Catholic Charities USA')&.candidate

  describe '#search' do 
    context 'when searching without a filter' do 
      it 'returns correct results' do
        expect(searcher.search('Server', {})[0].results).to include(server)
      end

      context 'when searching with a filter' do 
        it 'returns correct results' do 
          expect(searcher.search('Case Manager', {company_name: 'Catholic Charities USA'})[0].results).to include(case_manager)
          expect(searcher.search('Server', {company_name: 'Oceans & Ale'})[0].results).to include(server)
        end

        it 'returns correct title match count' do 
          expect(searcher.search('Manager', {})[2]['titles']['buckets'].sum { |b| b['doc_count'] }).to eq(35)
        end

        it 'returns correct titles' do 
          expect(searcher.search('Manager', {})[2]['titles']['buckets'].map { |b| b['key'] }).to include(
            "Account Executive",
            "Adwords Account Strategist",
            "Assembler",
            "Assistant",
            "Assistant Convention Director/Public Relations & Marketing Assistant",
            "Assistant Manager Cosmetics Dept",
            "Associate Director",
            "Case Manager",
            "Digital Media Coordinator",
            "Digital Strategist - SEM - SEO -SMM",
            "Event Services Specialist",
            "Event Specialist",
          )
        end

        it 'returns correct years of experience match count' do 
          expect(searcher.search('Manager', {})[2]['years_of_experience']['buckets'].sum { |b| b['doc_count'] }).to eq(5)
          expect(searcher.search('Manager', {})[2]['years_of_experience']['buckets'].find { |k, v| k['key'] == '16+' }['doc_count']).to eq(4)
          expect(searcher.search('Manager', {})[2]['years_of_experience']['buckets'].find { |k, v| k['key'] == '11-15' }['doc_count']).to eq(1)
        end

        it 'returns correct company names match count' do 
          expect(searcher.search('Manager', {})[2]['company_names']['buckets'].sum { |b| b['doc_count'] }).to eq(31)
        end

        it 'returns correct company names' do 
          expect(searcher.search('Manager', {})[2]['company_names']['buckets'].map { |b| b['key'] }).to include(
            "3D Brooklyn",
            "AT&T",
            "BMW of North America, LLC",
            "Beam Suntory",
            "Catholic Charities USA",
            "Cingular Wireless",
            "Condor Travel",
            "Elbow Beach Bermuda",
            "Fiserv",
          )
        end
      end
    end
  end

  describe '#miles_to_meters' do 
    context 'when given a number' do 
      it 'should return miles converted to meters' do
        expect(searcher.miles_to_meters(10)).to eq(16093.4)
        expect(searcher.miles_to_meters(1)).to eq(1609.34)
        expect(searcher.miles_to_meters(0)).to eq(0)
      end
    end
  end
end
  