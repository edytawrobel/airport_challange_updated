class Airport

  def initialize(capacity)
    @capacity = capacity
    @planes = []

  end

  def land(plane)
    raise 'Cannot land plane: airport full' if full?
    raise 'Cannot land plane: weather stormy' if stormy?
    @planes << plane
  end

  def take_off(plane)
  end

  private

  def full?
    @planes.length >= @capacity
  end

  def stormy?
    #Kernel.rand(1..6) > 4
    rand(1..6) > 4
  end
end
