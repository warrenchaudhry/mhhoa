class ReportsController < ApplicationController

  def index
    params[:start_date] ||= Date.today.beginning_of_month
    params[:end_date] ||= Date.today.end_of_month
    @payments = MonthlyDuePayment.
                  includes(homeowner: :street).
                  where(paid_at: params[:start_date]..params[:end_date], paid: true).
                  order(billable_month: :asc, billable_year: :asc).
                  sort_by {|k| [k.paid_at] }.group_by { |p| [p.homeowner, p.paid_at]}
    #render json: @payments
  end
end