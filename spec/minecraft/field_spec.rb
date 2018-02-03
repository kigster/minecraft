require 'spec_helper'

RSpec.describe MineCraft::Field do
  let(:string) { File.read('spec/fixtures/mines-small.txt') }
  subject(:field) { described_class.new(string) }
  let(:total) { field.total }
  context '#initialize' do
    it 'should load into the array' do
      expect(field.width).to eq 3
      expect(field.height).to eq 3
    end
  end

  context '#value_at' do
    it 'should respond to coordinates' do
      expect(field.value_at(x: -1, y: 0)).to be_nil
      expect(field.value_at(x: 0, y: 0)).to eq(1)
      expect(field.value_at(x: 1, y: 0)).to eq(0)
      expect(field.value_at(x: 2, y: 0)).to eq(1)
      expect(field.value_at(x: 0, y: 2)).to eq(0)
      expect(field.value_at(x: 1, y: 1)).to eq(0)
      expect(field.value_at(x: 4, y: 1)).to be_nil
    end
  end

  context '#total' do
    its(:total) { should eq 2 }
  end

  context 'value=' do
    let(:coords) { [1, 1] }
    it 'should properly set values' do
      expect(field.value(*coords)).to eq 0
      field.value!(*coords, :hello)
      expect(field.value(*coords)).to eq :hello
    end
  end

  context '#explode' do
    context 'without a mine reaction' do
      let(:mines) { field.explode(0, 2) }
      let(:exploded) { <<-eof
X.1
...
...
      eof
      }
      before { expect(mines).to eq(0) }
      its(:damage) { should eq 0 }
      its(:total) { should eq 2 }
      its(:to_s) { should eq exploded }
    end

    context 'with a mine with chain reaction' do
      let(:exploded) { <<-eof
X  
   
...
      eof
      }

      before do
        field.value!(1, 0, 1)
        expect(field.mine?(0, 0)).to be(true)
        expect(field.mine?(1, 0)).to be(true)
        expect(field.mine?(2, 0)).to be(true)
      end

      let(:mines) { field.explode(1, 0) }

      it 'should find and explode 3 mines total' do
        expect(mines).to eq(3)
        expect(field.to_s).to eq(exploded)
        expect(field.damage).to eq(6)
      end
    end

    context 'without a chain reaction' do
      let(:mines) { field.explode(0, 0) }
      before { expect(mines).to eq 1 }
    end
  end

  context '#biggest' do
    before { field.value!(1, 0, 1) }
    subject(:result) { field.biggest }

    its(:x) { should eq 0 }
    its(:y) { should eq 0 }
    its(:mines) { should eq 3 }

  end

end
