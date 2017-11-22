class CalculationsController < ApplicationController
    def new
        @calculation = Calculation.new
    end

    def all
        @user = current_user
        @calculations = @user.calculations.all
    end

    def edit
        @calculation = Calculation.find(params[:calculation_id])
    end

    def update
        @calculation = Calculation.find(params[:calculation_id])
            if @calculation.update(calculation_params)
                flash[:success] = "Calculation Updated"
                redirect_to calculations_path
            else
               render 'edit'
            end
    end

    def delete
        @calculation = Calculation.find(params[:calculation_id])
        if @calculation.CalculationRecords.delete
            if @calculation.delete
                    flash[:success] = "Calculation Deleted!"
                    redirect_to calculations_path
            else
                flash[:alert] = "There was a problem with deleting your calclation, please try again"              
                redirect_to calculations_path
            end
        else
                flash[:alert] = "There was a problem with deleting your calclation, please try again"              
                redirect_to calculations_path
        end

    end

    def show
        @user = current_user
        if @user.calculations.find_by(id: params['calculation_id'])
            @calculation = @user.calculations.find_by(id: params['calculation_id'])
            @top_three = @calculation.calculation_records.group_by { |r| r["total"] }
                                                            .sort_by  { |k, v| -k }
                                                            .first(3)
                                                            .map(&:last)
                                                            .flatten                                                       
        else
            flash[:alert] = "You do not have this calculation!"
            redirect_to root_path
        end
    end
    def create
        params = calculation_params
        params['user'] = current_user
        infoFromDb = ApiService.getRates(params["base_currency"], params["target_currency"])
        if infoFromDb != "ERROR"
            todaysRate = infoFromDb[0]
            infoFromDb.delete_at(0)
            params['date'] = Date.parse(todaysRate['date'])
            params['rate'] = todaysRate['rates']
            @calculation = Calculation.new(params)
            if @calculation.save()
                if CalculationRecord.SaveRecordsForCalculation(todaysRate, infoFromDb, params['base_amount'].to_f, @calculation)
                    redirect_to calculations_path
                    else
                    flash[:alert] = "There was a problem with your calculation, please try again. Cannot save Calculation to Database."
                    redirect_to calculation_new_path
                end
            else
                flash[:alert] = "There was a problem with your calculation, please try again. Cannot save Calculation to Database."
                redirect_to calculation_new_path
            end
        else
            flash[:alert] = "There was a problem with your calculation, please try again. API responded with error"
            redirect_to calculation_new_path
        end

    end


    private
    def calculation_params
        params.require(:calculation).permit(:base_currency, :target_currency, :period, :base_amount)
    end
    
end