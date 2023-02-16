# frozen_string_literal: true

require "rails_helper"

RSpec.describe "csv_uploads/show" do
  before do
    assign(:csv_upload, CsvUpload.create!(
                          title: "Title"
                        ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
  end
end
