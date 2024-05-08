class ActivityLog < ApplicationRecord
  belongs_to :item
  belongs_to :user

  validates :action, presence: true
end
