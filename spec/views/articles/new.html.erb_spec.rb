require 'rails_helper'

RSpec.describe "articles/new", type: :view do
  let(:article) {
    create(:article,
           title: "My article title",
           content: "My article content"
          )
  }
  let(:class_name) { 'article' }
  let(:input_field_target) {
    "#{class_name}_content_trix_input_#{class_name}_#{article.id}"
  }

  # This looks weird but it's done so we don't have to passin
  # @article value to the described view
  before(:each) do
    @article = article
  end

  it "renders the new article form" do
    render

    assert_select "form[action=?][method=?]", article_path(article), "post" do
      assert_select "input[name=?]", "article[title]"

      # For some reason the trix-editor is not visible in here by name.
      # This ensures that the input "content" is rendered BEFORE we have
      # an existing trix-editor
      assert_select "input[name=?]", 'content'

      assert_select "trix-editor[input=?]", input_field_target
    end
  end
end
