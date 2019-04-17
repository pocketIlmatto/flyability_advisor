def check_error_response(status)
  expect(response_data[:status])
    .to eq(::Rack::Utils::SYMBOL_TO_STATUS_CODE[status])
end