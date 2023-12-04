# frozen_string_literal: true

module HTTPLite
  module JSON
    def self.stringify(obj)
      fail NotImplementedError
    end

    def self.parse(str)
      fail NotImplementedError
    end
  end

  def self.get(url, headers = {}, follow_redirects = true)
    fail NotImplementedError
  end

  def self.post(url, stringhash, headers = {}, follow_redirects = true)
    fail NotImplementedError
  end

  def self.post_body(url, bodycontent, contenttype, headers = {}, follow_redirects = true)
    fail NotImplementedError
  end

end
