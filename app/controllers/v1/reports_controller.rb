class V1::ReportsController < ApplicationController
  def stock_report
    report_type = params[:stock_report_type]
    
    render json:  {
      responseCode: 200, responseMessage: "success",
      stockReportList: StockReport.perform(store_id: params[:store_id], group_by: params[:stock_report_type].upcase).stock_report
    }
  end

  def stock_money
    response = StockMoney.perform(store_id: params[:store_id])
    render json: {
      responseCode: 200, responseMessage: "success",
      dataPoints: [response.excess_stock_value, response.low_stock_value, response.slow_stock_value],
      labels: ["Excess Stock", "Low Stock", "Slow Stock"]
    }
  end
end
