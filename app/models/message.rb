class Message < ApplicationRecord
  belongs_to :manga
  validates :content, presence: true
end
