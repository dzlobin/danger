require 'spec_helper'
require 'pathname'
require 'tempfile'
require 'danger/dangerfile'
require 'danger/standard_error'

def make_temp_file(contents)
  file = Tempfile.new('dangefile_tests')
  file.write contents
  file
end

describe Danger::Dangerfile do
  it 'keeps track of the original Dangerfile' do
    file = make_temp_file ""
    dm = Danger::Dangerfile.from_ruby file.path
    expect(dm.defined_in_file).to be file.path
  end

  it 'runs the ruby code inside the Dangerfile' do
    code = "puts 'hi'"
    expect_any_instance_of(Danger::Dangerfile).to receive(:puts).and_return("")
    Danger::Dangerfile.from_ruby(Pathname.new(""), code)
  end

  it 'raises elegantly with bad ruby code inside the Dangerfile' do
    code = "asdas = asdasd + asdasddas"
    expect {
      Danger::Dangerfile.from_ruby(Pathname.new(""), code)
    }.to raise_error(Danger::DSLError)
  end

end
