class Match < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  has_many :messages, dependent: :destroy

  enum status: {
    pending: 0,
    accepted: 1,
    rejected: 2
  }
end
