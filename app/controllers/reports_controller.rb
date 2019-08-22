class ReportsController < ApplicationController

  def index
    params[:start_date] ||= Date.today.beginning_of_month
    params[:end_date] ||= Date.today.end_of_month
    @payments = MonthlyDuePayment.
                  includes(homeowner: :street).
                  where(paid_at: params[:start_date]..params[:end_date], paid: true).
                  order(billable_month: :asc, billable_year: :asc).
                  sort_by {|k| [k.paid_at] }.group_by { |p| [p.homeowner, p.paid_at]}
    respond_to do |format|
      format.html
      format.json { render json: @payments }
      format.pdf do
        render  pdf: "collection_report_#{params[:start_date]}_to_#{params[:end_date]}",
                layout: 'layouts/pdf.html',
                orientation: 'Portrait',
                page_size: 'Letter',
                margin: {
                  top: 30,
                  bottom: 30,
                  left: 15,
                  right: 15
                },
                title: 'Alternate Title',
                show_as_html: params.key?('debug'),
                lowquality: true
      end
    end
  end
end