require 'rails_helper'

RSpec.describe "articles/show", type: :view do
  let(:article) {
    create(:article,
           title: "My article title",
           content: "My article content"
          )
  }

  before(:each) do
    @article = article
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/#{article.title}/)
    expect(rendered).to match(/#{article.content}/)
  end
end
