module GetResponseData

  def response_data
    HashWithIndifferentAccess.new(JSON.parse(response.body))
  end

end

RSpec.configure do |config|
  config.include GetResponseData, type: :controller
end