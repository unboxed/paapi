# frozen_string_literal: true

module Api
  module V1
    class PlanningApplicationsController < ApplicationController
      def index
        @planning_applications = if params[:uprn].present?
                                   Property.find_by(uprn: params[:uprn]).planning_applications
                                 else
                                   PlanningApplication.all
                                 end
      end
    end
  end
end
