class PaymentsController < ApplicationController
  before_action :get_payment, only: [:show, :edit, :update, :destroy]
  def index
    params[:year] ||= Date.today.year
    @payments_data = Homeowner.payments_data(year: params[:year])
    respond_to do |format|
      format.html
      format.json { render json: @payments_data }
      format.pdf do
        render  pdf: "batch_payments_#{params[:year]}",
                layout: 'layouts/pdf.html',
                orientation: 'Landscape',
                page_size: 'Letter',
                title: 'Alternate Title',
                show_as_html: params.key?('debug'),
                lowquality: true,
                font_size: '10'
      end
    end
  end

  def batch
    params[:year] ||= Date.today.year
    @payments_data = Homeowner.payments_data(year: params[:year])
    # render json: @payments_data
  end

  def show; end

  def edit; end

  def update
    payment_params = params.require(:payments).permit!
    if @payment.update(payment_params)
      flash[:notice] = 'Successfully updated'
      redirect_to payment_path(@payment)
    else
      flash[:warning] = 'Unable to save record'
      redirect_to edit_payment_path(@payment)
    end
  end

  def process_batch
    payment_params = params.require(:payments).permit!
    params[:paid_at] = params[:paid_at].present? ? params[:paid_at] : Date.current
    processed, not_processed = MonthlyDuePayment.process_batch_payments(payment_params, params[:paid_at])
    if not_processed.any?
      render json: not_processed
    else
      flash[:success] = "Successfully processed #{processed.size} payments."
      redirect_to payments_path(year: params[:year])
    end

  end

  private

  def get_payment
    @payment = MonthlyDuePayment.find(params[:id])
  end
end