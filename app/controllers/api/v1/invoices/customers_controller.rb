class Api::V1::Invoices::CustomersController< ApplicationController
  def show
    invoice = Invoice.find(params[:id])
    render json: invoice.customers
  end 
end 