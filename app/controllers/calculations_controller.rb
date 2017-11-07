class CalculationsController < ApplicationController
    def new
        @calculation = Calculation.new
    end
    def create
        params = calculation_params
        params['user'] = current_user
        infoFromDb = ApiService.getRates(params["base_currency"], params["target_currency"])
        if infoFromDb != "ERROR"
            todaysRate = infoFromDb[0]
            infoFromDb.delete_at(0)
            params['date'] = Date.parse(todaysRate['date'])
            @calculation = Calculation.new(params)
            if @calculation.save()
                CalculationRecord.SaveRecordsForCalculation(todaysRate, infoFromDb, params['base_amount'].to_f, @calculation)
            else
                flash[:notice] = "There was a problem with your calculation, please try again. Cannot save Calculation to Database."
                redirect_to calculation_new_path
            end
        else
            flash[:notice] = "There was a problem with your calculation, please try again. API responded with error"
            redirect_to calculation_new_path
        end

    end
    private
    def calculation_params
        params.require(:calculation).permit(:base_currency, :target_currency, :period, :base_amount)
    end
    
end