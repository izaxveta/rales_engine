class Api::V1::InvoiceItems::FindController < ApplicationController
  def index
    render json: InvoiceItem.find_invoice_item(invoice_item_params)
  end

  private

  def invoice_item_params
    params[:unit_price].delete!(".") if params[:unit_price]
    params.permit(:id, :item_id, :invoice_id, :quantity, :unit_price, :created_at, :updated_at)
  end
end