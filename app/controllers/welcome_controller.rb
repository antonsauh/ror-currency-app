class WelcomeController < ApplicationController
    skip_before_action :authenticate_user!, only: [:index]
    def index
    end
    def new
        rates = getRates("EUR", "USD")
        # todaysRate = rates[0]
        # rates.delete_at(0)
        # total = 0
        # puts todaysRate

    end

    def getRates(base, rates)
        require 'net/http'  
        url = URI('http://sheltered-hollows-68796.herokuapp.com/rates') 
        req = Net::HTTP::Get.new(url) 
        req['base'] = base 
        req['rates'] = rates
        res = Net::HTTP.start(url.host, url.port) {|http|http.request(req)} 
        puts res.header
        return JSON.parse(res.body)
    end

    # def calculateRates(rate)

    # end

end