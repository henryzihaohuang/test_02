require 'rails_helper'

RSpec.describe Pipeline, type: :model do
  let(:user) { FactoryBot.create(:user) }
  describe 'associations' do 
    it { should belong_to(:user) }
    it { should have_many(:saved_candidates) }
    it { should have_many(:candidates) }
  end

  describe 'validations' do 
    it { should validate_presence_of(:name) }
  end

  describe '.reverse_chronological' do 
    it 'returns pipleines in descending order of created_at' do 
      third_pipeline = FactoryBot.create(:pipeline, user_id: user.id, created_at: Date.today - 2)
      second_pipeline = FactoryBot.create(:pipeline, user_id: user.id, created_at: Date.today - 1)
      first_pipeline = FactoryBot.create(:pipeline, user_id: user.id, created_at: Date.today) 
      
      expect(user.pipelines.reverse_chronological).to eq([
        first_pipeline, 
        second_pipeline,
        third_pipeline
      ])
    end
  end
end
