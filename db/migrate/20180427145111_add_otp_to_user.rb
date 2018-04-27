# frozen_string_literal: true

class AddOtpToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :encrypted_otp_secret, :string
    add_column :users, :encrypted_otp_secret_iv, :string
    add_column :users, :encrypted_otp_secret_salt, :string
    add_column :users, :consumed_timestamp, :datetime
    add_column :users, :consumed_timestep, :integer
  end
end
