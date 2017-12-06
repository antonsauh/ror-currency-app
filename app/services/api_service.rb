# API Service
class ApiService
  def self.get_rates(base, rates)
    require 'net/http'
    url = URI('http://sheltered-hollows-68796.herokuapp.com/rates')
    req = Net::HTTP::Get.new(url)
    req['base'] = base
    req['rates'] = rates
    res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
    return 'ERROR' unless res.code == '200'
    JSON.parse(res.body)
  end
end
