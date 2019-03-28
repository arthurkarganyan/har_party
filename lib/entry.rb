module HarParty
  class Entry
    attr_reader :body
    attr_accessor :url

    def initialize(body)
      @body = body
    end

    def url
      @url ||= URI.parse @body["request"]["url"]
    end

    def host
      @host ||= url.host
    end

    def request
      @request ||= body["request"]
    end

    def response
      @response ||= body["response"]
    end

    def status
      @status ||= response["status"]
    end

    def content
      @content ||= response["content"]
    end

    def content_html?
      content["mimeType"] == "text/html"
    end

    def pic?
      content["mimeType"]['image']
    end

    def type
      content["mimeType"]
    end

    def path
      url.path
    end

    def short
      "#{request["method"]}\t#{type}\t#{request["url"]}"
    end

    def font?
      !!url.to_s[/\.woff\Z/]
    end

    def httparty_request_headers
      @httparty_request_headers ||= request["headers"].map do |i|
        [i["name"], i["value"]]
      end.to_h
    end

    def httparty_request_query
      @httparty_request_query || request["queryString"].map do |i|
        [i["name"], i["value"]]
      end.to_h
    end

    def run!(session_id = nil)
      if request["method"] == 'GET'
        HTTParty.get(
            url,
            query: httparty_request_query,
            headers: httparty_request_headers
        )
      elsif request["method"] == 'POST'
        hh = httparty_request_headers.merge(cookie: session_id)
        HTTParty.post(
            url,
            query: httparty_request_query,
            headers: hh
        )
      else
        fail NotImplementedError
      end
    end


    # require 'zlib'
    # require 'stringio'
    # gz = Zlib::GzipReader.new(StringIO.new(resp.body.to_s))
    # uncompressed_string = gz.read
    #
  end
end
