module UrlHelper
  def url_with_protocol(url)
      /^http/.match(url) ? url : "http://#{url}"
  end
end
