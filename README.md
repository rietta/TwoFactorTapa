I've written this script in Markdown.  It is copied here from the private Github repository that I started. Happy to add you to the source.

# RubyTapas #534 - Two Factor Authentication Demo Application

## Script

### Why
Of all of the big data breaches involving web applications in recent years, 63% have been perpetrated through the use of compromised credentials! That is the bad guys simply log in using a valid username and password of a legitimate user. Even though there are many interesting technical ways that web-based software may be compromised, such as
- SQL injection,
- cross site scripting,
- session hijacking,
- and the other issues covered on the [OWASP Top 10](https://www.owasp.org/index.php/Category:OWASP_Top_Ten_Project),

as developers we cannot ignore the plight of the username and password.

Any users' account credentials being compromised is bad. But the worst case is a
compromise of a staff or administrative users, who have access to OTHER users'
personal information. This is a recipe for a data breach.

Here are some examples of ways these credentials could be compromised:
- A user might choose passwords that are truly weak and are easily compromised
  through a password cracking attack.
- Someone might reuse a password among multiple accounts. For instance, a CEO
  who uses the same e-mail and password everywhere. If *any* of those services
  are compromised, an attacker could use those credentials to target the site
  we're trying to protect.
- An attacker might lure a user to use a faked login page that looks like ours.
  This is known as a "spearphishing attack".

The problem is so prevalent that U.S. National Institute for Science and
Technology adopted a Federal standard in 2017 to address best practice
guidelines for password verifiers. The standard is called [NIST Special
Publication 800-63B, Digital Identity
Guidelines](https://pages.nist.gov/800-63-3/sp800-63b.html). This standard
challenges many of the recommendations you might have come across for password
security.

For example the requirement that users change their password every 90 days is
specifically *not* recommended by the NIST standard. One practice that *is*
strongly recommended by the NIST standard is to use multi-factor authentication.

Today we're going to be talking about a subset of multi-factor authentication:
two-factor authentication.

### What is Two Factor Authentication?

So what is two-factor authentication? Two factor authentication means that to
log in, a user must have something more than his or her username and password.
So "two-factor" really means having three pieces of information to authenticate
yourself with a system:
- Something you **are**: Your username.
- Something you **know**: Your password.
- Something you **have**: The "second factor".

A good way to do this is to require users, especially staff users, to use a smartphone app to generate a **time-based two factor code**.

Now, you’ve probably seen these time-based code implementations in some of the
big name services that you use online, like Gmail and Dropbox, and you might be
surprised how easy it is to add it to your Ruby application!

### How Does TOTP Work?

<!-- slide(n): mathematical representation of algorithm -->

<!--
For the graphic:
- TC = floor((unixtime(now) − unixtime(T0)) / TI),
- TOTP = HOTP(SecretKey, TC),
- TOTP-Value = TOTP mod 10^6
(Source [Wikpedia](https://en.wikipedia.org/wiki/Time-based_One-time_Password_algorithm)).
-->

The Time-based One-time Password algorithm is an open standard. It is a hash-based algorithm that uses the shared secret along with the current timestamp to compute a six digit code that changes each minute and can only be used once.  

Thankfully your users don't need to remember this math because their
smartphones keep track of it! And equally
thankfully, there are a few really good Ruby gem implementations that can be
used on the server side so that you can easily add TOTP to your Ruby
applications today!

There are three aspects that you have to handle though to add TOTP to your web application. Enrollment, verification, and backup codes.

<!-- [avdi] For VO, read titles as e.g. "let's talk about Enrollment" -->

#### Enrollment

On enrollment, we present our user with a QR barcode that is an encoding of
a secret string. But they can also be shown the raw code itself as you see
here.

<!-- slide(n): [PICTURE OF 2FA CODE] -->

The user scans the QR code with their smartphone, or enters the secret string
into the phone. To complete the enrollment, they type in the 6 digit TOTP code
that their two-factor app is showing them into our website.


[PICTURE OF ENTERING THE CODE]

After this, the server can confirm that the user has in his or her posession a
full-enrolled device, and we're all set!

#### Verification

This one is easy. Ask for the user's 6 digit code and pass it along to the
verifier gem.

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

Implementing two factor authentication is a necessary step to providing good web
application security. You could spend tons of time and money on other security
measures to harden your system, but without two-factor, a user who makes a poor choice of
password or falls victim to a spearphishing attack could render all of those
safeguards inneffective.

The next step will be to ensure that as many users as
possible make use of the feature. You should consider requiring those with
administrative access to use 2FA.  And finally, don't just implement but be a
user. Many of the websites and services that we Rubyists use in our daily work,
such as Heroku, Github, and AWS support 2FA. Use it everywhere for your and your
customers' protection.
