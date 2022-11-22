# frozen_string_literal: true

class PlanningApplicationsProperty < ApplicationRecord
  belongs_to :planning_application
  belongs_to :property
end
