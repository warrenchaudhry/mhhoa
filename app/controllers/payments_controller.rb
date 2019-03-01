class PaymentsController < ApplicationController

  def index
    params[:year] ||= Date.today.year
    @payments_data = Homeowner.payments_data(year: params[:year])
  end

  def batch
    params[:year] ||= Date.today.year
    @payments_data = Homeowner.payments_data(year: params[:year])
    #render json: @payments_data
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
end