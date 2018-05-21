class TwoFactorQrCodesController < ApplicationController
  layout 'blank'
  def create
    # Note! This user will not actually be created.
    # It's just being used to render the QR code.
    @enrolling_user = User.new(email: params[:email])
    @enrolling_user.otp_secret = params[:enrolling_otp_secret]
  end
end
