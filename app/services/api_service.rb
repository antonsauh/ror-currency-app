class ApiService
  def self.getRates(base, rates)
    require 'net/http'
    url = URI('http://sheltered-hollows-68796.herokuapp.com/rates')
    req = Net::HTTP::Get.new(url)
    req['base'] = base
    req['rates'] = rates
    res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
    if res.code == '200'
      return JSON.parse(res.body)
    else
      return 'ERROR'
    end
  end
end
