module Output
  module Naming
    extend self

    def fully_qualified(mod, writer_name)
      namespace = mod.name
      writer_name = camel_case(writer_name)
      "#{namespace}::#{writer_name}"
    end

    def camel_case(sym)
      sym.to_s.split('_').collect { |s| s.capitalize }.join
    end
  end
end
