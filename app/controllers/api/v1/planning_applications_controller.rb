module Api
  module V1
    class PlanningApplicationsController < ApplicationController
      def index
        @planning_applications = PlanningApplication.all
      end
    end
  end
end
