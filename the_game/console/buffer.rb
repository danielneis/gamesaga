module Console
  class Buffer

    def initialize(size)
      @buffer = Array.new
      @size = size
      @current_line = 0
    end

    def add(content)
      @buffer.delete_at 0 if @buffer.size == @size
      @buffer << content
      @current_line += 1
    end

    def last
      @buffer.last
    end

    def empty?
      @buffer.empty?
    end

    def size_used
      @buffer.size
    end

    def previous
      @current_line -= 1 unless @current_line == 0
      if @buffer.empty?
        ''
      else
      @buffer[@current_line].dup 
      end
    end

    def next
      @current_line += 1 unless @current_line == (@buffer.size)
      if @buffer[@current_line].nil?
        ''
      else
        @buffer[@current_line].dup
      end
    end
  end
end
