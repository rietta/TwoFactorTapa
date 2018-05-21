### Why
Sixty three percent of the big data breaches involving web apps in recent years have been perpetrated via compromised credentials! That is the bad guys simply log in using a valid username and password. Despite other technical ways that apps are routinely popped, many that are covered by the OWASP Top 10, as developers we cannot ignore the plight of the username and password.

It's bad when any user's credentials are compromised, but
it's worse it's a staff user who has access to OTHER people's data.
That's a recipe for a data breach.

(~34 seconds)
So what are some ways these credentials are stolen?
It could be
- A user choses passwords that are *truly weak* and
  easily broken by password cracking.

- or one who reuses a password among multiple websites.
  If *any* of those other third parties are compromised, an attacker can use those credentials to target the site we're trying to protect.

- Or a user is lured to use a faked login page that looks like ours. This is known as a "spearphishing attack".

(~24 seconds)

(~1 minute)

The problem is so prevalent that
U.S. National Institute for Science and
Technology adopted the
NIST 800-63b Federal standard for password verifiers.

It challenges many of the recommendations you might have come across for password security.

For example making users change their password every 90 days is
specifically *not* recommended.

One thing that *is* strongly recommended is to use multi-factor authentication.

Today we're talking about a subset of multi-factor authentication. Two factor authentication!

(~33 seconds)

(~ 1:30 seconds runtime)

### What is Two Factor Authentication?

 That means the user must have something more than their username and password.

So "two-factor" really means having three pieces of information to authenticate yourself with a system:

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

The time-based one-time password algorithm is an open standard.

It works by hashing a shared secret with current timestamp to compute a six digit code that changes each minute and can only be used once.  

There are multiple good smartphone apps for your users to choose from.

There are three aspects that you have to handle to add TOTP to your web application. Enrollment, verification, and backup codes.

<!-- [avdi] For VO, read titles as e.g. "let's talk about Enrollment" -->

( ~ 3 minutes into recording)

#### Enrollment

On enrollment, we present our user with a QR barcode that is an encoding of a secret string. But they can also be shown the raw code itself as you see
here.

<!-- slide(n): [PICTURE OF 2FA CODE] -->


[PICTURE OF ENTERING THE CODE]

The user scans or enters the secret and then types the current six digit code into our web form to confirm enrollment.

#### Verification

When a user account has 2FA enabled, enforce the required current valid 6 digit TOTP for authentication.

#### Backup Codes

You need to provide backup codes in case your user looses their smartphone or deletes the app.

### Code Example!
I’m showing an example of a Ruby on Rails that shows DELICIOUS tapas to authenticated users. We're adding TOTP via the devise-two-factor gem.

[VIDEO OF INTERACTING WITH WEB BROWSER, LOGGING IN AND SEEING A DELICIOUS TAPA]

#### How is this Done

##### Gemfile
[CODE EDITOR SCREEN CAP]

I've added a few gems to Gemfile:

- devise for user authentication
- devise-two-factor
- and a library to natively generate QR codes without leaking secrets to some web API

Because we'll load the encryption secret from an environment variable, I've added a gem to support that in local too.

##### User model / migration to show fields needed for the 2FA implementation
[CODE EDITOR SCREEN CAP]

The migration adds a 5 fields to the user model.

The first three manage the symmetric encryption of the shared secret so that its not stored in the database in plaintext, which would be bad!

The next keeps a record of the most recently used code so replays are rejected.

And finally if 2FA is enabled for the user.

In the user model, you see that we enabled the
two_factor_authenticatable auth strategy and loaded
the OTP encryption secret.

##### Verifying a current 2FA code not just on login
[CODE EDITOR SCREEN CAP]

### Conclusion

Implementing two factor authentication is a necessary step to providing good web
application security. You could spend tons of time and money on other security
measures to harden your system, but without two-factor, a user who makes a poor choice of
password or falls victim to a spearphishing attack could render all of those
safeguards ineffective.

The next step will be to ensure that as many users as
possible make use of the feature. You should consider requiring those with
administrative access to use 2FA.  And finally, don't just implement but be a
user. Many of the websites and services that we Rubyists use in our daily work,
such as Heroku, Github, and AWS support 2FA. Use it everywhere for your and your
customers' protection.


(over 10 seconds)

(negative 1:34)

































... END ...
