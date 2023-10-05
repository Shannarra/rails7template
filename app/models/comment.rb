class Comment < ApplicationRecord
  belongs_to :article
  broadcasts_to :article

  has_rich_text :content
  validates :content, presence: { message: "can't be blank" }

  before_save :check_internal_content

  # Delete all invalid records if any using:
  # Comment.empty_comments.map(&:destroy)
  scope :empty_comments, -> { all.reject(&:valid?) }

  private
  def check_internal_content
    !content.body.to_s.empty?
  end
end
