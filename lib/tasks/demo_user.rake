# frozen_string_literal: true

namespace :demo_user do
  desc 'Create a demo user with a password and 2FA code'
  task setup: :environment do
    email = 'rubyist@example.com'
    if User.where(email: email).any?
      puts "User #{email} already exists"
      next
    end

    password = SecureRandom.hex(5)
    enrolling_otp_secret = User.generate_otp_secret

    user = User.create(
      email: email,
      password: password,
      otp_secret: enrolling_otp_secret,
      otp_required_for_login: true
    )

    puts "\nAdd the following OTP secret to your smartphone app:"\
         "\n\n#{enrolling_otp_secret}"\
         "\n\nOnce that is complete, you can login with:"\
         "\nE-mail: #{email}" \
         "\nPassword: #{password}" \
         "\nOTP Code: <the current six digit code from your app>"\
         "\n Demo only cheat, you can use #{user.current_otp} for the next minute"
  end
end
