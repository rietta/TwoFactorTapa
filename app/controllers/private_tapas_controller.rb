# frozen_string_literal: true

class PrivateTapasController < ApplicationController
  before_action :authenticate_user!, except: [:public]

  def show; end

  def public
    if user_signed_in?
      redirect_to(private_tapas_path, only_root: true)
    else
      redirect_to(
        new_user_session_path,
        only_root: true,
        notice: 'Please login to see delicious tapas.'
      )
    end
  end
end
