# frozen_string_literal: true

#  Model of association between user's tackle_box and baits
class TackleBoxItem < ApplicationRecord
  belongs_to :user
  belongs_to :bait, counter_cache: true
end
