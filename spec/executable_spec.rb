require 'shellwords'
require 'fileutils'

describe 'bin/htmlbeautifier' do
  before do
    FileUtils.mkdir_p path_to('tmp')
  end

  def write(path, content)
    File.open(path, 'w') do |f|
      f.write content
    end
  end

  def read(path)
    File.read(path)
  end

  def path_to(*partial)
    File.join(File.expand_path('../..', __FILE__), *partial)
  end

  def command
    'ruby -I%s %s' % [
      escape(path_to('lib')),
      escape(path_to('bin', 'htmlbeautifier'))
    ]
  end

  def escape(s)
    Shellwords.escape(s)
  end

  it 'beautifies a file in place' do
    input = "<p>\nfoo\n</p>"
    expected = "<p>\n  foo\n</p>\n"
    path = path_to('tmp', 'in-place.html')
    write path, input

    system '%s %s' % [command, escape(path)]

    expect(read(path)).to eq(expected)
  end

  it 'beautifies a file from stdin to stdout' do
    input = "<p>\nfoo\n</p>"
    expected = "<p>\n  foo\n</p>\n"
    in_path = path_to('tmp', 'input.html')
    out_path = path_to('tmp', 'output.html')
    write in_path, input

    system '%s < %s > %s' % [command, escape(in_path), escape(out_path)]

    expect(read(out_path)).to eq(expected)
  end

  it 'allows a configurable number of tab stops' do
    input = "<p>\nfoo\n</p>"
    expected = "<p>\n   foo\n</p>\n"
    path = path_to('tmp', 'in-place.html')
    write path, input

    system '%s --tab-stops=3 %s' % [command, escape(path)]

    expect(read(path)).to eq(expected)
  end
end
