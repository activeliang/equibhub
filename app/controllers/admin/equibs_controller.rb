class Admin::EquibsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_required
  layout "admin"
  def new
    @equib = Equib.new
  end

  def create
    @equib = Equib.new(equib_params)
    if @equib.save
      redirect_to admin_equibs_path,notice: "已新增！"
    else
      render :back
    end
  end

  def index
    @equibs = Equib.all

    respond_to do |format|
      format.html
      format.csv { send_data @equibs.to_csv }
      format.xls # { send_data @products.to_csv(col_sep: "\t") }
    end
  end

  def edit
    @equib = Equib.find(params[:id])
  end

  def update
    @equib = Equib.find(params[:id])
    if @equib.update(equib_params)
      redirect_to admin_equibs_path, notice: "更新成功！"
    else
      render :edit
    end
  end

  def show
    @equib = Equib.find(params[:id])
    @repairs = @equib.repairs
    require 'rqrcode'

   qrcode = RQRCode::QRCode.new("http://github.com/")
   image = qrcode.as_png
   svg = qrcode.as_svg
   html = qrcode.as_html
   string = qrcode.as_ansi
   string = qrcode.to_s
    @qr = RQRCode::QRCode.new(equib_url(@equib).to_s, :size => 4, :level => :h )
  end

  def destroy
    @equib = Equib.find(params[:id])
    @equib.destroy
    redirect_to admin_equibs_path, alert: "已删除！"
  end

  def meter
    @equibs = Equib.all
    flash[:notice] = "hahahahab"
  end

  private

  def equib_params
    params.require(:equib).permit(:title, :department, :position, :principal, :purchase_date, :is_for_production, :use_state, :origin, :model, :supplier, :warranty, :description, :price, :age_limit, :image)
  end
end
