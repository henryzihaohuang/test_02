require 'rails_helper'

RSpec.describe SavedCandidate, type: :model do
  describe 'associations' do 
    it { should belong_to(:pipeline) }
    it { should belong_to(:candidate) }
  end
end
