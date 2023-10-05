class Article < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_rich_text :content

  validates :title,
            presence: {:message => "can't be blank" },
            length: { minimum: 10, maximum: 100, message: "must be between 10 and 100 characters" }

  validates :content,
            presence: {:message => "can't be blank" },
            length: { maximum: 100_000, message: "must be max 100_000 characters" }
end
