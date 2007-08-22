module Console
  class Buffer

    def initialize(size)
      @buffer = Array.new
      @size = size
    end

    def add_content(content)
      @buffer.delete_at 0 if @buffer.size == @size
      @buffer << content
    end

    def last
      @buffer.last
    end
  end
end
