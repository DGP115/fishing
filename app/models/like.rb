# frozen_string_literal: true

#  Fisch castch Likes model
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :fish_catch, counter_cache: true

  # Turbo_Stream broadcasts re new like activity
  after_create_commit do
    broadcast_prepend_later_to(
      'activity_update',
      target: 'catches',
      partial: 'activity/fish_catch',
      locals: { fish_catch: self }
    )
  end

  after_update_commit do
    broadcast_replace_later_to(
      'activity_update',
      target: self,
      partial: 'activity/catch_details',
      locals: { fish_catch: self }
    )
  end

  after_destroy_commit do
    broadcast_remove_to(
      'activity_update',
      target: self
    )
  end
end
