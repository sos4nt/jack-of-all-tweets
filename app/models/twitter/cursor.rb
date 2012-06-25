module Twitter

  class Cursor < Base
    include Enumerable

    attr_accessor :ids, :previous_cursor, :next_cursor

    def initialize(attributes={})
      super
    end

    def [](index)
      @ids[index]
    end

    def each &block
      @ids.each{|id| block.call(id)}
    end

    def first_page?
      previous_cursor.zero?
    end

    def last_page?
      next_cursor.zero?
    end

    def to_s
      @ids.to_s
    end
  end

end
