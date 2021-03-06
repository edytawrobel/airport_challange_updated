require 'airport'

describe Airport do
  subject(:airport) { described_class.new(weather_reporter, 20) }
  let(:plane) { double :plane, land: nil, take_off: nil }
  let(:weather_reporter) {double :weather_reporter}

  describe '#land' do
    context 'when not stormy' do
      before do
        allow(weather_reporter).to receive(:stormy?).and_return false
      end

      it 'instructs a plane to land' do
        expect(plane).to receive(:land)
        airport.land(plane)
      end

      context 'when full' do
        it 'raises an error' do
          20.times do
            airport.land(plane)
          end
          expect { airport.land(plane) }.to raise_error "Cannot land plane: capacity full"
        end
      end
    end

    context 'defaults' do
      subject(:default_airport) { described_class.new(weather_reporter) }

      it 'has default capacity' do
        allow(weather_reporter).to receive(:stormy?).and_return false
        described_class::DEFAULT_CAPACITY.times { default_airport.land(plane) }
        expect { default_airport.land(plane) }.to raise_error "Cannot land plane: capacity full"
      end
    end

    context 'when stormy' do
      it 'raises an error' do
        allow(weather_reporter).to receive(:stormy?).and_return true
        expect { airport.land(plane) }.to raise_error 'Cannot land plane: weather stormy'
      end
    end
  end


  describe '#take_off' do
    context 'when not stormy'
    before do
      allow(weather_reporter).to receive(:stormy?).and_return false
    end

      it 'instructs a plane to take off' do
        airport.land(plane)
        expect(plane).to receive(:take_off)
        airport.take_off(plane)
      end

      it 'returns the plane that took off' do
        airport.land(plane)
        expect(airport.take_off(plane)).to eq plane
      end

      it 'raises an error if plane is not at this airport' do
        other_airport = described_class.new(weather_reporter, 20)
        other_airport.land(plane)
        expect { airport.take_off(plane) }.to raise_error "cannot take off plane: plane is not at this airport"
      end
    end

    context 'when stormy' do
      before do
        allow(weather_reporter).to receive(:stormy?).and_return true
      end

      it 'raises an error' do
        expect { airport.take_off(plane) }.to raise_error 'Cannot take off plane: weather stormy'
      end
    end
end
