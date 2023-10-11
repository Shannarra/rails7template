class Article < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_rich_text :content

  MIN_TITLE_LENGTH = 10
  MAX_TITLE_LENGTH = 100
  MAX_CONTENT_LENGTH = 100_000

  validates :title,
            presence: {:message => "can't be blank" },
            length: {
              minimum: MIN_TITLE_LENGTH,
              maximum: MAX_TITLE_LENGTH,
              message: "must be between 10 and 100 characters"
            }

  validates :content,
            presence: {:message => "can't be blank" },
            length: { maximum: MAX_CONTENT_LENGTH, message: "must be max 100_000 characters" }
end
