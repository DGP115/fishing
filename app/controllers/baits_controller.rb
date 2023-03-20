# frozen_string_literal: true

#  Baits Controller
class BaitsController < ApplicationController
  def index
    @baits = Bait.search(params)

    @bait_categories = Bait.pluck(:category).uniq

    @baits = current_user.assign_my_tackle_box_items_to_baits(@baits) if signed_in?

  end

  def show
    @bait = Bait.find(params[:id])

    @top_catches = @bait.fish_catches
                        .order(weight: :desc)
                        .limit(10)
                        .includes(:user)
  end
end
