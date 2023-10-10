require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:first_article) { create(:article) }


  describe 'can be created' do
    it 'creates a new article' do
      expect(first_article).to be_valid
      expect(Article.count).to eq 1
    end
  end
end
