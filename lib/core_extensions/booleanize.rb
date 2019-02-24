module CoreExtensions::Booleanize
  module String
    def to_bool
      return true if self == true || self =~ (/^(true|t|yes|y|1)$/i)
      return false if self == false || self.blank? || self =~ (/^(false|f|no|n|0)$/i)
      raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
    end
  end

  module Fixnum
    def to_bool
      return true if self == 1
      return false if self == 0
      raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
    end
  end

  module TrueClass
    def to_i; 1; end
    def to_bool; self; end
  end

  module FalseClass
    def to_i; 0; end
    def to_bool; self; end
  end

  module NilClass
    def to_bool; false; end
  end
end