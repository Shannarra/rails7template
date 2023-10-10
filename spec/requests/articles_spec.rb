require 'rails_helper'

RSpec.describe "Articles", type: :request do

  let(:invalid_attributes) {
    {
      att: 1,
      att2: 'something'
    }
  }

  let(:valid_attributes) {
    {
      title: Faker::Book.title,
      content: Faker::Lorem.paragraph
    }
  }

  describe "GET /index" do
    it "renders a successful response" do   
      create(:article)
      get articles_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      article = create(:article)
      get article_url(article)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_article_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      article = create(:article)
      get edit_article_url(article)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Article" do
        expect {
          post articles_url, params: { article: valid_attributes }
        }.to change(Article, :count).by(1)
      end

      it "redirects to the created article" do
        post articles_url, params: { article: valid_attributes }
        expect(response).to redirect_to(article_url(Article.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Article" do
        expect {
          post articles_url, params: { article: invalid_attributes }
        }.to change(Article, :count).by(0)
      end

      it "renders a 422 response" do
        post articles_url, params: { article: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {
          title: Faker::Book.title,
          content: Faker::Lorem.paragraph
        }
      }

      it "updates the requested article" do
        article = create(:article)
        patch article_url(article), params: { article: new_attributes }
        article.reload

        expect(article.title).to eq new_attributes[:title]
        expect(article.content.to_plain_text).to eq new_attributes[:content]
      end

      it "redirects to the article" do
        article = create(:article)
        patch article_url(article), params: { article: new_attributes }
        article.reload
        expect(response).to redirect_to(article_url(article))
      end
    end

    context "with invalid parameters" do
      it "renders a successful \"found\" response (i.e. 302)" do
        article = create(:article)
        patch article_url(article), params: { article: invalid_attributes }
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested article" do
      article = create(:article)
      expect {
        delete article_url(article)
      }.to change(Article, :count).by(-1)
    end

    it "redirects to the articles list" do
      article = create(:article)
      delete article_url(article)
      expect(response).to redirect_to(articles_url)
    end
  end


  describe "GET /articles" do
    it "works! (now write some real specs)" do
      get articles_path
      expect(response).to have_http_status(200)
    end
  end
end
