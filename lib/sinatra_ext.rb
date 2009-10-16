module Sinatra
  class Base
    class << self
      def copy(path, opts={}, &bk);    route 'COPY',    path, opts, &bk end
    end
  end
end