require 'rails_helper'

RSpec.describe "articles/index", type: :view do
  before(:each) do
    assign(:articles, [
      create(:article,
             title: "My article title",
             content: "My article content"
            ),
      create(:article,
             title: "My article title",
             content: "My article content"
            )
    ])
  end

  it "renders a list of articles" do
    render

    assert_select ".article-card>h3", text: "My article title".to_s, count: 2
    assert_select ".article-card>.trix-content", text: "My article content".to_s, count: 2
  end
end
