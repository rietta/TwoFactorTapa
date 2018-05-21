# frozen_string_literal: true

class PrivateTapasController < ApplicationController
  before_action :authenticate_user!, except: [:public]

  def show; end

  def public
    return unless user_signed_in?
    redirect_to private_tapas_path, only_root: true
  end
end
