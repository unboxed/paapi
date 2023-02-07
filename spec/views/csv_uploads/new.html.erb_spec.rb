require 'rails_helper'

RSpec.describe "csv_uploads/new", type: :view do
  before(:each) do
    assign(:csv_upload, CsvUpload.new(
      title: "MyString"
    ))
  end

  it "renders new csv_upload form" do
    render

    assert_select "form[action=?][method=?]", csv_uploads_path, "post" do

      assert_select "input[name=?]", "csv_upload[title]"
    end
  end
end
