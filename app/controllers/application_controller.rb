# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_current_user
  before_action :set_current_local_authority

  attr_reader :current_local_authority

  helper_method :current_local_authority

  private

  def set_current_user
    Current.user = current_user
  end

  def set_current_local_authority
    @current_local_authority ||= current_user&.local_authority if current_user
  end
end
