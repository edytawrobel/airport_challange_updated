describe 'these are the user stories' do

  let(:airport) { Airport.new(weather_reporter, 20) }
  let(:plane) { Plane.new }
  let(:weather_reporter) { WeatherReporter.new }

  context 'when not stormy' do
    before do
      allow(weather_reporter).to receive(:stormy?).and_return false
    end
  # As an air traffic controller
  # So I can get passengers to a destination
  # I want to instruct a plane to land at an airport and confirm that it has landed
    it 'so planes land at airports, instruct a plane to land' do
      expect { airport.land(plane) }.not_to raise_error
    end

#   As an air traffic controller
#   So I can get passengers on the way to their destination
#   I want to instruct a plane to take off from an airport and confirm that it is no longer in the airport
    it 'so planes take off from airports, instruct a plane to take off' do
      airport.land(plane)
      expect { airport.take_off(plane) }.not_to raise_error
    end


    # As an air traffic controller
    # To ensure safety
    # I want planes to take off from the airport they are at
    it 'takes off planes only from the airport they are at' do
      airport2 = Airport.new(weather_reporter, 20)
      airport2.land(plane)
      expect { airport.take_off(plane) }.to raise_error "cannot take off plane: plane is not at this airport"
    end

    # As the system designer
    # So that the software can be used for many different airports
    # I would like a default airport capacity that can be overridden as appropriate
    it 'airports have a default capacity' do
      default_airport = Airport.new(weather_reporter)
      Airport::DEFAULT_CAPACITY.times { default_airport.land(plane) }
      expect { default_airport.land(plane) }.to raise_error "Cannot land plane: capacity full"
    end
  end


  # As an air traffic controller
  # To ensure safety
  # I want to prevent landing when the airport is full
  it 'does not allow planes to land when airport is full' do
    allow(airport).to receive(:stormy?).and_return false
    20.times do
      airport.land(plane)
    end
    expect { airport.land(plane) }.to raise_error "Cannot land plane: capacity full"
  end


  # As an air traffic controller
  # To ensure safety
  # I want to prevent takeoff and landing when weather is stormy
  context 'when weather is stormy' do
    before do
      allow(weather_reporter).to receive(:stormy?).and_return true
    end

    it 'does not allow planes to land' do
      expect { airport.land(plane) }.to raise_error 'Cannot land plane: weather stormy'
    end

    it 'does not allow planes to take off' do
      expect { airport.take_off(plane)}.to raise_error 'Cannot take off plane: weather stormy'
    end
  end
end
