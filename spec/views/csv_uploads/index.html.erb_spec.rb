# frozen_string_literal: true

require "rails_helper"

RSpec.describe "csv_uploads/index" do
  before do
    assign(:csv_uploads, [
             CsvUpload.create!(
               title: "Title"
             ),
             CsvUpload.create!(
               title: "Title"
             )
           ])
  end

  it "renders a list of csv_uploads" do
    render
    div_selector = Rails::VERSION::STRING >= "7" ? "div>h2" : "tr>td"
    assert_select div_selector, text: Regexp.new("Title".to_s), count: 2
  end
end
