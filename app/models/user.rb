class User < ApplicationRecord
  has_many :envelope_users
  has_many :envelopes, through: :envelope_users
end
