class HomeownersController < ApplicationController
  before_action :set_homeowner, only: [:show, :edit, :update, :destroy]

  # GET /homeowners
  # GET /homeowners.json
  def index
    @homeowners = Homeowner.joins(:street).includes(:street).order('streets.position ASC').group_by { |h| h.street.name }
    respond_to do |format|
      format.html
      format.json { render json: @homeowners }
    end
  end

  # GET /homeowners/1
  # GET /homeowners/1.json
  def show; end

  # GET /homeowners/new
  def new
    @homeowner = Homeowner.new
  end

  # GET /homeowners/1/edit
  def edit; end

  # POST /homeowners
  # POST /homeowners.json
  def create
    @homeowner = Homeowner.new(homeowner_params)

    respond_to do |format|
      if @homeowner.save
        format.html { redirect_to @homeowner, notice: 'Homeowner was successfully created.' }
        format.json { render :show, status: :created, location: @homeowner }
      else
        format.html { render :new }
        format.json { render json: @homeowner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /homeowners/1
  # PATCH/PUT /homeowners/1.json
  def update
    respond_to do |format|
      if @homeowner.update(homeowner_params)
        format.html { redirect_to @homeowner, notice: 'Homeowner was successfully updated.' }
        format.json { render :show, status: :ok, location: @homeowner }
      else
        format.html { render :edit }
        format.json { render json: @homeowner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /homeowners/1
  # DELETE /homeowners/1.json
  def destroy
    @homeowner.destroy
    respond_to do |format|
      format.html { redirect_to homeowners_url, notice: 'Homeowner was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def payments
    params[:year] ||= Date.today.year
    @payments_data = Homeowner.payments_data(year: params[:year])
    #render json: @payments_data
  end

  def process_payments
    payment_params = params.require(:payments).permit!
    params[:paid_at] = params[:paid_at].present? ? params[:paid_at] : Date.current
    processed, not_processed = MonthlyDuePayment.process_batch_payments(payment_params, params[:paid_at])
    if not_processed.any?
      render json: not_processed
    else
      flash[:success] = "Successfully processed #{processed.size} payments."
      redirect_to payments_homeowners_path(year: params[:year])
    end

  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_homeowner
    @homeowner = Homeowner.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def homeowner_params
    params.require(:homeowner).permit(:firstname, :mi, :lastname, :street_id, :active, :payment_starts_on, :monthly_dues_discount)
  end
end
