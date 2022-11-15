# frozen_string_literal: true

module Api
  module V1
    class PlanningApplicationsController < ApplicationController
      skip_before_action :authenticate_token!, :set_local_authority, only: [:index]
      before_action :check_uprn_param_is_present,
                    :check_uprn_type_size, only: :index

      def index
        property = Property.find_by(uprn: params[:uprn])

        if property
          @planning_applications = property.planning_applications
        else
          render json: { message: "Unable to find record" }, status: :not_found
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

        render json: { message: "Applications created" }, status: :created
      rescue StandardError => e
        render json: { message: e }, status: :bad_request
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
          latitude
          longitude
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

      def check_uprn_param_is_present
        return if params[:uprn].present?

        render json: { message: "UPRN must be present to proceed" }, status: :bad_request
      end

      def check_uprn_type_size
        return if params[:uprn].match?(/(\d{12})$/)

        render json: { message: "UPRN must be a number 12 character" }, status: :bad_request
      end
    end
  end
end
