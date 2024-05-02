if @item_amount.persisted?
  json.inserted_item render(partial: "items/item_amounts_show",
                            locals: { item: @item, item_amount: @item_amount },
                            formats: :html)
  json.form render(partial: "item_amounts/new_item_amount_form",
                   locals: { item_amount: ItemAmount.new },
                   formats: :html)
else
  json.form render(partial: "item_amounts/new_item_amount_form",
                  locals: { item: @item, item_amount: @item_ammount },
                  formats: :html)
end
