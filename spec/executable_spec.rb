require 'shellwords'
require 'fileutils'

describe 'bin/htmlbeautifier' do
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
    FileUtils.mkdir_p path_to('tmp')
    input = "<p>\nfoo\n</p>"
    expected = "<p>\n  foo\n</p>\n"
    path = path_to('tmp', 'in-place.html')
    File.open(path, 'w') do |f|
      f.write input
    end

    system '%s %s' % [command, escape(path)]

    output = File.read(path)
    expect(output).to eq(expected)
  end

  it 'beautifies a file from stdin to stdout' do
    FileUtils.mkdir_p path_to('tmp')
    input = "<p>\nfoo\n</p>"
    expected = "<p>\n  foo\n</p>\n"
    in_path = path_to('tmp', 'input.html')
    out_path = path_to('tmp', 'output.html')
    File.open(in_path, 'w') do |f|
      f.write input
    end

    system '%s < %s > %s' % [command, escape(in_path), escape(out_path)]

    output = File.read(out_path)
    expect(output).to eq(expected)
  end

  it 'allows a configurable number of tab stops' do
    FileUtils.mkdir_p path_to('tmp')
    input = "<p>\nfoo\n</p>"
    expected = "<p>\n   foo\n</p>\n"
    path = path_to('tmp', 'in-place.html')
    File.open(path, 'w') do |f|
      f.write input
    end

    system '%s --tab-stops=3 %s' % [command, escape(path)]

    output = File.read(path)
    expect(output).to eq(expected)
  end
end
