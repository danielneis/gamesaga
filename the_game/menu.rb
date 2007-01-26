class Menu

  def initialize( items = [] )
    @items = items
    @items.collect do |item|
      item.width = 400
      item.l = 100
      item.r = 500
    end
  end

  def select_item(position)
    @items.each do |item|
      puts 'l = '+ item.l.to_s
      puts 'r = '+ item.r.to_s
      if position[0] >= item.l and position[0] <= item.r
        puts 'ok'
      else 
        puts position
      end
    end
  end
end
