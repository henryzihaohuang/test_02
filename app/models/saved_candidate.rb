class SavedCandidate < ApplicationRecord
  include ActiveStorageSupport::SupportForBase64

  belongs_to :pipeline
  belongs_to :candidate

  has_one_base64_attached :resume
end
