$(document).ready ->
  $('#email_for_qr_code').keyup (e) ->
    email_pattern = /^([\w.-]+)@([\w.-]+)\.([a-zA-Z.]{2,6})$/i
    email_address = $('#email_for_qr_code').val()
    return unless email_address.match(email_pattern)

    enrolling_otp_secret = $('#enrolling_otp_secret').text()

    # Submit the enrolling e-mail and OTP secret so that the server can
    # generate a QR code without hitting an external API. When the user
    # scans the code, it will conveniently show the name of our app
    # and the e-mail address for the account that is being enrolled.
    $.post '/two_factor_qr_codes',
      enrolling_user: {email: email_address, otp_secret: enrolling_otp_secret}
      (data) ->
        $('#2fa-qr-code').html(data)
