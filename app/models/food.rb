class Food < ApplicationRecord
  validates :name, :calories, presence: true

  has_many :meal_foods,  :dependent => :destroy
  has_many :meals, through: :meal_foods
end
