class Category < ApplicationRecord
  has_many :category_hobbies
  has_many :hobbies, through: :category_hobbies

  validates :name, presence: true
end
