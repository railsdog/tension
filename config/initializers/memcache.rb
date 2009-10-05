if ENV['MEMCACHE_SERVERS']
  require 'memcache'
  servers = ENV['MEMCACHE_SERVERS'].split(',')
  namespace = ENV['MEMCACHE_NAMESPACE']
  CACHE = MemCache.new(servers, :namespace => namespace)
else
  module Cache
    module_function

    def get(key, timeout=nil, &block)
      @cache ||= {}
      @cache[key] ||= block.call()
    end

    def delete(key)
      @cache ||= {}
      @cache.delete(key)
    end
  end
end
