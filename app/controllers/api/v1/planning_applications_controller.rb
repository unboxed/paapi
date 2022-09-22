module Api
  module V1
    class PlanningApplicationsController < ApplicationController
      def index
        if params[:uprn].present?
          @planning_applications = Property.find_by_uprn(params[:uprn]).planning_applications
        else
          @planning_applications = PlanningApplication.all
        end
      end
    end
  end
end
