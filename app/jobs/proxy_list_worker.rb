class ProxyListWorker < ActiveJob::Base
  require 'open-uri'
  require 'timeout'
  require 'socket'
  require 'proxy_list'

  def perform
    proxies = ProxyList.get_lists('UA')
    # ActiveRecord::Base.connection.execute("TRUNCATE free_proxies RESTART IDENTITY")
    proxies.each do |proxy|
      uri_obj = URI.parse(URI.escape(proxy))
      Timeout.timeout(20) do
        Net::HTTP.new('ya.ru', nil, uri_obj.host, uri_obj.port).start do |http|
          @response = response = http.request_get('ya.ru')
          FreeProxy.create(host: uri_obj.host, port: uri_obj.port, url: proxy) if response.kind_of?(Net::HTTPSuccess)
        end
      end rescue next
    end
  end
end