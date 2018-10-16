class OrdersController < ApplicationController
  def index
    @orders = Order.all
    @import = Import.new
  end

  def show
    @order = Order.find_by id: params[:id]
    @line_items = @order.line_items
    csv = ExportCsvService.new(@line_items, LineItem::CSV_ATTRIBUTES)

    respond_to do |format|
      format.html
      format.pdf do
        pdf = OrderPdf.new
        send_data pdf.render,
                  filename: "order_#{@order.order_number}",
                  type: 'application/pdf',
                  disposition: 'inline'
      end
      format.csv { send_data csv.perform.encode(Encoding::SJIS),
        filename: "lineitem.csv" }
    end
  end

  def import
    Order.import(params[:file])
    redirect_to root_url, notice: "Orders imported."
  end
end
