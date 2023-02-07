require "rails_helper"

RSpec.describe CsvUploadsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/csv_uploads").to route_to("csv_uploads#index")
    end

    it "routes to #new" do
      expect(get: "/csv_uploads/new").to route_to("csv_uploads#new")
    end

    it "routes to #show" do
      expect(get: "/csv_uploads/1").to route_to("csv_uploads#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/csv_uploads/1/edit").to route_to("csv_uploads#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/csv_uploads").to route_to("csv_uploads#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/csv_uploads/1").to route_to("csv_uploads#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/csv_uploads/1").to route_to("csv_uploads#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/csv_uploads/1").to route_to("csv_uploads#destroy", id: "1")
    end
  end
end
