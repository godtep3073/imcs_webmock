class Staffs::Reports::StaffCommissionsController < ApplicationController
  before_action :authenticate_staff!
  def index
    find_paid_orders_in_date_range!
    respond_staff_comission_report
  end

  private

  def find_paid_orders_in_date_range!
    @begin_date = params[:begin_date].blank? ? Date.today.beginning_of_month : Date.parse(params[:begin_date])
    @end_date = params[:end_date].blank? ? Date.today.end_of_month : Date.parse(params[:end_date])
    @staff_orders = Staff.joins(:sale_orders).group(:id).where(['order_orders.paid_approve_by_staff_id IS NOT ?', nil]).where(['order_orders.paid_full_date BETWEEN ? AND ?', @begin_date, @end_date]).page(params[:page]).per(params[:per_page])
  end

  def respond_staff_comission_report
    respond_to do |format|
      format.html { render 'index' }
    end
  end
end
