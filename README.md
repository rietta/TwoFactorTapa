# RubyTapas #534 - Two Factor Authentication Demo Application

## Script

### Why
Of all of the big data breaches involving web applications in recent years, 63% have been perpetrated through the use of compromised credentials! That is the bad guys simply log in using a valid username and password of a legitimate user. Even though there are many interesting technical ways that web-based software may be compromised, such as
- SQL injection,
- cross site scripting,
- session hijacking,
- and the other issues covered on the [OWASP Top 10](https://www.owasp.org/index.php/Category:OWASP_Top_Ten_Project),

as developers we cannot ignore the plight of the username and password.

While any users' account credentials being compromised is bad, the worst case is staff and administrative users who have access to administrative portals with OTHER users' personal information available. This is a recipe for a data breach.

These credentials may become compromised by:
- User chosen passwords that are truly weak and easily compromised through an online brute force attack
- Passwords that are re-used among accounts and have been compromised on the dark web (say the CEO likes to use the same e-mail and password everywhere)
- Targeted spear phishing attacks that get the user to enter his or her password on a faked login that looks like your app’s official login page but instead gives the credentials up to the attacker

The problem is so prevalent that U.S. National Institute for Science and Technology adopted a Federal standard in 2017 to address best practice guidelines for password verifiers. The standard is called [NIST Special Publication 800-63B, Digital Identity Guidelines](https://pages.nist.gov/800-63-3/sp800-63b.html). The standard challenges many of the practices that are regularly seen today such as limiting password length or making users change their passwords too often. It also strongly recommends the use of multi-factor authentication. As a pro-tip, being able to say your SaaS complies with the NIST 800-63b can be a great enterprise selling feature selling factor!

### What is Two Factor Authentication?

Two factor authentication means that to login a user must have something more than his or her username and password. That is really three things:
- username is something your user **is**,
- and a password is something he or she **knows**,
- the next step is to require something he or she **has**.

A good way to do this is to require users, especially staff users, to use a smartphone app to generate a time-based two factor code.

Now, you’ve probably seen these time-based code implementations in some of the big name services that you use online, like Gmail and Dropbox, but it’s also easy to add it to your Ruby application as well.

### How Does TOTP Work?
The Time-based One-time Password algorithm is an open standard. It is a hash-based algorithm that uses the shared secret along with the current timestamp to compute a six digit code that changes each minute and can only be used once.  

The method is defined as:

- TC = floor((unixtime(now) − unixtime(T0)) / TI),
- TOTP = HOTP(SecretKey, TC),
- TOTP-Value = TOTP mod 10^6

(Source [Wikpedia](https://en.wikipedia.org/wiki/Time-based_One-time_Password_algorithm)).

Thankfully the user does not need to remember this math because his or her smartphone will keep the secret key and compute the code on his or her behalf! And equally thankfully, there are a few really good Ruby gem implementations that can be used on the server side so that you can easily add TOTP to your Ruby applications today!

There are two aspects that you have to handle though to add TOTP to your web application. Enrollment, verification, and backup codes.

#### Enrollment

On enrollment, our user is presented with a QR barcode that is an encoding of the secret string. But they can also be shown the code itself as you see here.

[PICTURE OF 2FA CODE]

The user scans the QR code or enters the secret string and completes the enrollment by confirming to current 6 digit TOTP code.  

[PICTURE OF ENTERING THE CODE]

After this, the server can confirm that the user has in his or her position a device capable of generating a 6 digit code that can only be used one time and must be used within 60 seconds of its generation.

#### Verification

This one is easy. Ask for the user's 6 digit code and pass it along to the verifier.

#### Backup Codes

One complication of two factor authentication is what to do if the user looses his or her smartphone or the app gets deleted. Locking a user out of your application is bad for business but making it trivial to bypass two factor authentication is really bad for security.

Often this is solved by presenting the user with a series of one time use alternate codes that he or she can print and keep in a safe place. The devise-two-factor gem has support for this built in!

[PICTURE OF RESET CODES]

If all else fails, what you provide to recover accounts for when the 2FA and backup codes are lost depends on the sensitivity of your data and the risk the business faces to let an impostor into a users' account. For high security, financial systems it may be appropriate to require a notarized, certified letter from the account holder.

### Code Example!
While you can certainly implement TOTP in any Ruby application, I’m showing an example of the `devise-two-factor` and the `rqrcode-rails3` gems added to a basic everyday Ruby on Rails and Devise application. The complete sample app is available at https://github.com/rietta/TwoFactorTopa.

The Two Factor Tapa has login page that is available to the public and a secret lair page, where the member can see pictures of delicious tapas! However, because sharing these delicious tapas with unauthorized impostors would be a travesty, the user has to provide a current two factor code in addition to a password to login.

[VIDEO OF INTERACTING WITH WEB BROWSER, LOGGING IN AND SEEING A DELICIOUS TAPA]

#### How is this Done

##### Gemfile
[CODE EDITOR SCREEN CAP]

##### User model / migration to show fields needed for the 2FA implementation
[CODE EDITOR SCREEN CAP]

##### Verifying a current 2FA code not just on login
[CODE EDITOR SCREEN CAP]

### Conclusion
