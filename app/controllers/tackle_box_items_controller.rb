# frozen_string_literal: true

# Tacklebox controller
class TackleBoxItemsController < ApplicationController
  before_action :require_signin

  def index
    item = current_user.tackle_box_item_for_most_recent_catch

    if !item.nil?
      redirect_to action: :show, id: item
    else
      render 'tackle_box_items/empty'
    end
  end

  def show
    @item = current_user.tackle_box_items.find(params[:id])

    @items =
      current_user.tackle_box_items
                  .order(created_at: :asc)
                  .includes(:bait)

    @new_catch = current_user.fish_catches
                             .new(bait: @item.bait)

    @fish_catches =
      current_user.fish_catches
                  .where(bait: @item.bait)
                  .order(created_at: :desc)
  end

  def create
    @bait = Bait.find(params[:bait_id])
    @item = current_user.tackle_box_items.create!(bait: @bait)

    #  Assign the bait to my_tackle_box
    @bait.my_tackle_box_item = @item

    #  We want to update two portions of the dom here:
    #   - the "bait_1" partial to toggle the button on the bait between Add and Remove
    #   - the count of the itms in the tackle box
    #  To do that, we can use render a turbo_stream here.  To do that, use the rails default
    #  nomenclature for a create action and create file create.turbo_stream.erb
  end

  def destroy
    @item = current_user.tackle_box_items.find(params[:id])

    #  Translate the tackle_box_item sent via params into its associated bait
    @bait = @item.bait

    #  Destroy the tackle_box_item
    @item.destroy

    # We want to update the same two portions of the dom that we did in the create action.
    # So, just render the create turbo_steam
    render 'tackle_box_items/create'
  end
end
