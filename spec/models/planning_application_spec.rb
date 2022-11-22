# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlanningApplication, type: :model do
  context "when validations are run" do
    it "must have a reference set" do
      planning_application = build(:planning_application, reference: nil)
      planning_application.save

      expect(planning_application.errors.messages).to include(:reference)
    end

    it "must have a area set" do
      planning_application = build(:planning_application, area: nil)
      planning_application.save

      expect(planning_application.errors.messages).to include(:area)
    end

    it "must have a description set" do
      planning_application = build(:planning_application, description: nil)
      planning_application.save

      expect(planning_application.errors.messages).to include(:description)
    end

    it "must have at least one received_at set" do
      planning_application = build(:planning_application, received_at: nil)
      planning_application.save

      expect(planning_application.errors.messages).to include(:received_at)
    end

    it "must have the decision set" do
      planning_application = build(:planning_application, decision: nil)
      planning_application.save

      expect(planning_application.errors.messages).to include(:decision)
    end

    it "must have the decision_issued_at set" do
      planning_application = build(:planning_application, decision_issued_at: nil)
      planning_application.save

      expect(planning_application.errors.messages).to include(:decision_issued_at)
    end

    it "must have the local_authority set" do
      planning_application = build(:planning_application, local_authority: nil)
      planning_application.save

      expect(planning_application.errors.messages).to include(:local_authority)
    end
  end
end
