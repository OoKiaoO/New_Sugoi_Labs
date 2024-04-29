class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy] #:show_item_amount
  

  def home
    items = Item.all
    current_month = Date.today
    next_month = Date.today.next_month
    next_next_month = Date.today.next_month(2)
    
    @current_month_items = get_monthly_items(items, get_monthly_range(current_month))
    @next_month_items = get_monthly_items(items, get_monthly_range(next_month))
    @next_next_month_items = get_monthly_items(items, get_monthly_range(next_next_month))
  end

  def index
    #TODO: add backup for empty inventory (no items found)
    # TODO: make filters apply to prev. searched query results only, if present
    # add conditional in each filter 
    # @items = params[:filter].present? ? Item.search_by_all_item_info(params[:query]).order(brand: :asc) : ...?
    if params[:query].present?
      @items = Item.search_by_all_item_info(params[:query])
    elsif params[:filter].present? && params[:filter] == 'brand'
      @items = Item.all.order(brand: :asc)
    elsif params[:filter].present? && params[:filter] == 'category'
      @items = Item.all.order(category: :asc)
    elsif params[:filter].present? && params[:filter] == 'location'
      @items = Item.all.order(location: :asc)
    else
      @items = Item.all.order(name: :asc)
    end
  end

  def show
    @item_amount = ItemAmount.new
    # @unchecked_amounts = @item.item_amounts.select {|amount| !amount.checked}
    
    # unless @item.item_amounts.empty?
    #   if @item.item_amounts.count == 1
    #     @item_amounts = @item.item_amounts.order(created_at: :desc)
    #     @data_values = [@item.item_amounts.first.amount]
    #     @data_keys = ['Expiring next']
    #   else
    #     chart_data = get_chart_data
    #     @data_values = chart_data[:data_values]
    #     @data_keys = chart_data[:data_keys]
    #     @exp_amounts = @item.item_amounts.select {|amount| amount.checked}
    #     @waste_data = get_waste_chart_data(@exp_amounts)
    #     @data_waste_keys = @waste_data.map {|item| item[:month] }
    #     @data_waste_values = @waste_data.map {|item| item[:total] }

    #     if params[:option] == 'amount#reload'
    #       @item_amounts = @item.item_amounts.order(amount: :desc)
    #     elsif params[:option] == 'exp#reload'
    #       @item_amounts = @item.item_amounts.order(exp_date: :asc)
    #     elsif params[:option] == 'remaining'
    #       @item_amounts = @item.item_amounts.order(exp_date: :asc)
    #     else
    #       @item_amounts = @item.item_amounts.order(created_at: :desc)
    #     end
    #   end
    # end
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.save!

    # if @item.save
    #   log(@item.id, "Created new item")
    # end

    redirect_to item_path(@item)
  end

  def edit
  end

  def update
    @item.update(item_params)

    # if @item.save
    #   log(@item.id, "Updated item's info")
    # end

    redirect_to item_path(@item)
  end

  def destroy
    @item.destroy

    redirect_to items_path
  end


  private


  def item_params
    params.require(:item).permit(:name,
                                 :brand,
                                 :barcode,
                                 :secondary_barcode,
                                 :description,
                                 :category,
                                 :location,
                                 :retail,
                                 :photo)
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def get_monthly_range(month)
    beginning_of_month = month.beginning_of_month
    end_of_month = beginning_of_month.end_of_month
    (beginning_of_month..end_of_month)
  end

  def get_monthly_items(items, range)
    items_results = []
    total_items = 0

    items.each do |item|
      results = item.item_amounts.where(exp_date: range) # check for item_amounts with exp_date in current month
      unless results.empty? # unless the search for exp_dates in current month returned empty, do the following:
        items_results << item # save the current item in results array, used to be displayed in expiring soon view page
        total_items += results.sum(:amount) # get the total number of item_amounts included in the specified range & add to total
      end
    end
    {
      items: items_results,
      total_items: total_items
    }
  end
end
