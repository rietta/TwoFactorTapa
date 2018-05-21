class TwoFactorQrCodesController < ApplicationController
  layout 'blank'
  def create
    # Note! This user will not actually be created.
    # It's just being used to render the QR code.
    @enrolling_user = User.new(enrolling_user_params)
  end

  def enrolling_user_params
    params.require(:enrolling_user).permit(:email, :otp_secret)
  end
end
