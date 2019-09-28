require 'json'


module DeskLight
  class Response
    attr_reader :code
    attr_reader :json
    attr_reader :limit
    attr_reader :remaining
    attr_reader :reset
    attr_reader :body
    attr_reader :either
    attr_reader :time
    attr_reader :headers

    def initialize _response, _time = nil
      @limit = _response['x-rate-limit-limit']
      @limit = @limit.to_i if @limit
      @remaining = _response['x-rate-limit-remaining']
      @remaining = @remaining.to_i if @remaining
      @reset = _response['x-rate-limit-reset']
      @reset = @reset.to_i if @reset
      @code = _response.code.to_i
      if content_type = _response['content-type']
        if content_type.include?("application/json")
          begin
            @json = JSON.parse(_response.body)
          rescue
            @json = nil
          end
        end
      else
        @json = nil
      end
      @body = _response.body
      @either = @json || @body
      @time = (Time.now - _time).to_f if _time
      @headers = {}
      _response.each do |key,val|
        @headers.merge!(key => val)
      end
    end
  end
end
