# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  email                     :string           default(""), not null
#  encrypted_password        :string           default(""), not null
#  reset_password_token      :string
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :string
#  last_sign_in_ip           :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  consumed_timestamp        :datetime
#  encrypted_otp_secret      :string
#  encrypted_otp_secret_iv   :string
#  encrypted_otp_secret_salt :string
#  consumed_timestep         :integer
#  otp_required_for_login    :boolean          default(FALSE)
#

class User < ApplicationRecord
  auto_strip_attributes :email

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :two_factor_authenticatable, # Remember to remove database_authenticatable
         # :two_factor_backupable,    # For production use, you'll want backup codes
         otp_secret_encryption_key: ENV['OTP_SECRET_ENCRYPTION_KEY']

  ###############################
  # OTP Enrollment Support
  #
  # You'll probably want to use a service object for a production-grade
  # implementation.
  #
  attr_accessor :enrolling_otp_secret
  before_validation :setup_enrolling_otp, on: :create
  validates :enrolling_otp_secret, presence: true, format: {with: /\A[a-zA-Z0-9]*\z/ }, on: :create
  validate :validate_otp_secret_matches, on: :create

  private

  def setup_enrolling_otp
    return if persisted? || enrolling_otp_secret.nil?
    self.otp_required_for_login = true
    self.otp_secret = enrolling_otp_secret
  end

  def validate_otp_secret_matches
    return if validate_and_consume_otp!(otp_attempt)
    errors.add(:otp_attempt, 'Does not match expected code. Please check again.')
    return false
  end
end
