# frozen_string_literal: true

require "rails_helper"

RSpec.describe "csv_uploads/edit" do
  let(:csv_upload) do
    CsvUpload.create!(
      title: "MyString"
    )
  end

  before do
    assign(:csv_upload, csv_upload)
  end

  it "renders the edit csv_upload form" do
    render

    assert_select "form[action=?][method=?]", csv_upload_path(csv_upload), "post" do
      assert_select "input[name=?]", "csv_upload[title]"
    end
  end
end
