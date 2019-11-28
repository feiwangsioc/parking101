class ParkingsController < ApplicationController
   before_action :authenticate_user! 
    # Step1: 显示开始停车的表单
    def index
      @parkings = Parking.order("id DESC").all
    end 
    
    
    def new
      @parking = Parking.new
    end
 
    # Step2: 新建一笔停车，纪录下开始时间
    def create
      @parking = Parking.new(:start_at => Time.now)
      @parking.parking_type = params[:parking][:parking_type]
      @parking.plate = params[:parking][:plate]
      @parking.user = current_user
    
      if @parking.save
 
        redirect_to parking_path(@parking)
      else 
        render :new
      end 
    end
 
    # Step3: 如果还没结束，显示结束停车的表单
    # Step5: 如果已经结束，显示停车费用。
    def show
      @parking = Parking.find(params[:id])
    end
 
 # Step4: 结束一笔停车，记录下结束时间，并且计算停车费
    def update
      @parking = Parking.find(params[:id])
      @parking.end_at = Time.now
      @parking.calculate_amount
 
      @parking.save!
 
      redirect_to parking_path(@parking)
    end
    
    def destroy 

     @parking = Parking.find(params[:id])
     @parking.destroy
     flash[:alert] = " Deleted "
     redirect_to parkings_path

    end 
    # private 
    # def parking_params
    #   params.require(:parking).permit(:parking_type => "guest", :plate =>"" , :start_at => Time.now)
    # end 

end
