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
    # TODO: add backup for empty inventory (no items found)
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
    @unchecked_amounts = @item.item_amounts.where(checked: nil)
    
    unless @unchecked_amounts.empty?
      if @unchecked_amounts.count == 1
        @item_amounts = @item.item_amounts.order(created_at: :desc)
        @data_values = [@item.item_amounts.first.amount]
        @data_keys = ['Expiring next']
      else
        chart_data = get_chart_data
        @data_values = chart_data[:data_values]
        @data_keys = chart_data[:data_keys]
        @exp_amounts = @item.item_amounts.select { |amount| amount.checked}
        @data_waste_keys = get_waste_chart_data(@exp_amounts).map { |item| item[:month] }
        @data_waste_values = get_waste_chart_data(@exp_amounts).map { |item| item[:total] }

        case params[:option]
        when 'amount'
          @unchecked_amounts = @unchecked_amounts.order(amount: :desc)
        when 'exp'
          @unchecked_amounts = @unchecked_amounts.order(exp_date: :asc)
        when 'remaining'
          @unchecked_amounts = @unchecked_amounts.order(exp_date: :asc)
        else
          @unchecked_amounts = @unchecked_amounts.order(created_at: :desc)
        end
      end
    end
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    # @item.save!

    if @item.save
      log(@item.id, "Created new item")
      redirect_to item_path(@item), notice: 'Item was succesfully created.'
    else
      render :new, status: :unprocessable_entity
    end
    # raise
  end

  def edit
  end

  def update
    @item.update(item_params)

    if @item.save
      log(@item.id, "Updated item's info")
      redirect_to item_path(@item), notice: 'Item was succesfully updated.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy

    redirect_to items_path, status: :see_other
  end

  def expiring_soon
    items = Item.all
    current_month = Date.today
    next_month = Date.today.next_month
    next_next_month = Date.today.next_month(2)

    @current_month_items = get_monthly_items(items, get_monthly_range(current_month))
    @next_month_items = get_monthly_items(items, get_monthly_range(next_month))
    @next_next_month_items = get_monthly_items(items, get_monthly_range(next_next_month))

    if params[:start_date].present? && params[:end_date].present?
      range = (params[:start_date]..params[:end_date])
      @filtered_items = get_monthly_items(items, range)
    elsif params[:monthly_items].present?
      @filtered_items = {
        items: params[:monthly_items].map { |item| Item.find(item) }
      }
    end
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

  def show_item_amount
    all_amounts = []
    @item.item_amounts.each { |item_amount| all_amounts << item_amount.amount }
    all_amounts.sum
  end

  def get_chart_data
    sorted_exp_date = @item.item_amounts.order(exp_date: :asc)
    not_expired = sorted_exp_date.select {|amount| !amount.checked}
    expiring_next = not_expired.count < 1 ? 0 : not_expired.first.amount
    upcoming = not_expired.count <= 1 ? 0 : not_expired[1].amount
    remaining = not_expired.drop(2)
    remaining_amounts = remaining.map { |remaining_amount| remaining_amount.amount }
    remaining_total = remaining_amounts.sum
    {
      data_values: [expiring_next, upcoming, remaining_total],
      data_keys: ['Expiring next', 'Upcoming', 'Remaining']
    }
  end

  def get_waste_chart_data(exp_amounts)
    # data_values: sort waste log entries by month -> arranged in hash-map
    # data_keys: create months entries based on entries from data_values

    # Group entries by both month and year
    sorted_hash = exp_amounts.group_by { |amount| [amount.exp_date.year, amount.exp_date.strftime('%B')] }

    # Convert month name to month number to facilitate sorting
    month_mapping = {"January" => 1, "February" => 2, "March" => 3, "April" => 4, "May" => 5,
    "June" => 6, "July" => 7, "August" => 8, "September" => 9, "October" => 10, "November" => 11, "December" => 12}

    # Prepare the data for the chart, summing amounts for each month-year pair
    data = sorted_hash.map do |(year, month), amounts|
      total_amount = amounts.sum { |item| item.exp_amount }
      { year: year, month: month, total: total_amount }
    end

    # Sort data by year first, then by month
    data.sort_by! { |entry| [entry[:year], month_mapping[entry[:month]]] }
  end
end
