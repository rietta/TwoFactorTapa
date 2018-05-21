$(document).ready ->
  $('#email_for_qr_code').keyup (e) ->
    email_pattern = /^([\w.-]+)@([\w.-]+)\.([a-zA-Z.]{2,6})$/i
    email_address = $('#email_for_qr_code').val()

    return unless email_address.match(email_pattern)

    enrolling_otp_secret = $('#enrolling_otp_secret').text()

    console.log("Processing email " + email_address + " and secret " + enrolling_otp_secret)
    $.post '/two_factor_qr_codes',
      query: {email: email_address, enrolling_otp_secret: enrolling_otp_secret}
      (data) ->
        $('#2fa-qr-code').html(data)
