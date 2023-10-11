require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:first_article) { create(:article) }

  describe 'with valid attributes' do
    it 'creates a new article' do
      expect(first_article).to be_valid
      expect(Article.count).to eq 1
    end
  end

  describe 'with invalid attributes' do
    context 'when empty' do
      let(:empty_article) { create(:article, title: '', content: '') }

      it 'does not create a new article' do
        expect {
          empty_article
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when violating min-max boundaries' do
      let(:invalid_article) {
        create(:article,
               title: 'a' * (1 +  Article::MAX_TITLE_LENGTH),
               content: 'a'* (1 + Article::MAX_CONTENT_LENGTH) }

      it 'does not create a new article' do
        expect {
          invalid_article
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
