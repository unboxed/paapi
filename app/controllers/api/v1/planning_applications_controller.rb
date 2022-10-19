# frozen_string_literal: true

module Api
  module V1
    class PlanningApplicationsController < ApplicationController
      skip_before_action :authenticate_token!, :set_local_authority, only: [:index]

      def index
        @planning_applications = if params[:uprn].present?
                                   Property.find_by(uprn: params[:uprn]).planning_applications
                                 else
                                   PlanningApplication.all
                                 end
      end

      def create
        ActiveRecord::Base.transaction do
          planning_applications_params.each do |attributes|
            PlanningApplicationCreation.new(
              **attributes.to_h.symbolize_keys
            ).perform
          end
        end

        head :created
      rescue StandardError => e
        render(json: e, status: :bad_request)
      end

      private

      def planning_applications_params
        params.require(:planning_applications).map do |attributes|
          attributes.permit(permitted_attributes).merge(local_authority: @local_authority)
        end
      end

      def permitted_attributes
        %i[
          assessor
          application_type
          application_type_code
          area
          code
          decision
          decision_issued_at
          description
          full
          map_east
          map_north
          postcode
          received_at
          reference
          reviewer
          town
          type
          uprn
          validated_at
          view_documents
          ward_code
          ward_name
        ]
      end
    end
  end
end
