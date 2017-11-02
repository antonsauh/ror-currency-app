class CalculationsController < ApplicationController
    def new
        @calculation = Calculation.new
    end
    def create
        p = calculation_params
        p['user'] = current_user
        infoFromDb = getRates(p["base_currency"], p["target_currency"])
        if infoFromDb != "ERROR"
            todaysRate = infoFromDb[0]
            infoFromDb.delete_at(0)
            p['date'] = todaysRate['date']
            arrayOfRates = []
            infoFromDb.each do | rate |
                arrayOfRates << rate["rates"]
            end
            a = forecast(todaysRate['rates'].to_f, arrayOfRates)
            b = forecast(todaysRate['rates'].to_f , arrayOfRates)
            puts a.inspect
            puts b.inspect

            # if Calculation.create(p)
            #     puts "SAVED TO DB"
            # else
            #     flash[:notice] = "There was a problem with your calculation, please try again"
            #     redirect_to calculation_new_path
            # end
        else
            flash[:notice] = "There was a problem with your calculation, please try again"
            redirect_to calculation_new_path
        end

    end
    private
    def calculation_params
        params.require(:calculation).permit(:base_currency, :target_currency, :period, :base_amount)
    end

    def getRates(base, rates)
        require 'net/http'  
        url = URI('http://sheltered-hollows-68796.herokuapp.com/rates') 
        req = Net::HTTP::Get.new(url) 
        req['base'] = base 
        req['rates'] = rates
        res = Net::HTTP.start(url.host, url.port) {|http|http.request(req)}
        if res.code == '200'
            return JSON.parse(res.body)
        else
            return "ERROR"
        end
    end
    def forecast(todayRate, array)
        someArray = []
        someNumber = 0
        someIt = 1
        array.each do | item |
            someNumber += item
            someArray << (item * (todayRate.to_f / (someNumber.to_f / someIt.to_f)).round(2)).round(2)
            someIt = someIt + 1
        end
        return someArray
    end
end