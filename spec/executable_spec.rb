require "shellwords"
require "fileutils"
require "open3"

describe "bin/htmlbeautifier" do
  before do
    FileUtils.mkdir_p path_to("tmp")
  end

  def write(path, content)
    File.open(path, "w") do |f|
      f.write content
    end
  end

  def read(path)
    File.read(path)
  end

  def path_to(*partial)
    File.join(File.expand_path("../..", __FILE__), *partial)
  end

  def command
    "ruby -I%s %s" % [
      escape(path_to("lib")),
      escape(path_to("bin", "htmlbeautifier"))
    ]
  end

  def escape(s)
    Shellwords.escape(s)
  end

  it "beautifies a file in place" do
    input = "<p>\nfoo\n</p>"
    expected = "<p>\n  foo\n</p>\n"
    path = path_to("tmp", "in-place.html")
    write path, input

    system "%s %s" % [command, escape(path)]

    expect(read(path)).to eq(expected)
  end

  it "beautifies a file from stdin to stdout" do
    input = "<p>\nfoo\n</p>"
    expected = "<p>\n  foo\n</p>\n"
    in_path = path_to("tmp", "input.html")
    out_path = path_to("tmp", "output.html")
    write in_path, input

    system "%s < %s > %s" % [command, escape(in_path), escape(out_path)]

    expect(read(out_path)).to eq(expected)
  end

  it "displays which files would fail with --lint-only flag" do
    good_input = "<p></p>\n"
    good_path = path_to("tmp", "good.html")
    write(good_path, good_input)

    bad_input = "<div><p></p></div>\n"
    bad_path = path_to("tmp", "bad.html")
    write(bad_path, bad_input)

    expected_message = "Lint failed - files would be modified:\ntmp/bad.html\n"

    stdout, _stderr, status = Open3.capture3(
      "%s %s %s --lint-only" % [command, escape(good_path), escape(bad_path)]
    )

    expect(status.exitstatus).to eq(1)
    expect(stdout).to eq(expected_message)
  end

  it "does not modify files with --lint-only flag" do
    good_input = "<p></p>\n"
    good_path = path_to("tmp", "good.html")
    write(good_path, good_input)

    bad_input = "<div><p></p></div>\n"
    bad_path = path_to("tmp", "bad.html")
    write(bad_path, bad_input)

    system("%s %s %s --lint-only" % [command, escape(good_path), escape(bad_path)])

    expect(read(good_path)).to eq(good_input)
    expect(read(bad_path)).to eq(bad_input)
  end

  it "allows a configurable number of tab stops" do
    input = "<p>\nfoo\n</p>"
    expected = "<p>\n   foo\n</p>\n"
    path = path_to("tmp", "in-place.html")
    write path, input

    system "%s --tab-stops=3 %s" % [command, escape(path)]

    expect(read(path)).to eq(expected)
  end

  it "allows indentation with tab instead of spaces" do
    input = "<p>\nfoo\n</p>"
    expected = "<p>\n\tfoo\n</p>\n"
    path = path_to("tmp", "in-place.html")
    write path, input

    system "%s --tab %s" % [command, escape(path)]

    expect(read(path)).to eq(expected)
  end

  it "allows an initial indentation level" do
    input = "<p>\nfoo\n</p>"
    expected = "      <p>\n        foo\n      </p>\n"
    path = path_to("tmp", "in-place.html")
    write path, input

    system "%s --indent-by 3 %s" % [command, escape(path)]

    expect(read(path)).to eq(expected)
  end

  it "ignores closing tag errors by default" do
    input = "</p>\n"
    expected = "</p>\n"
    path = path_to("tmp", "in-place.html")
    write path, input

    status = system("%s %s" % [command, escape(path)])

    expect(read(path)).to eq(expected)
    expect(status).to be_truthy
  end

  it "raises an exception on closing tag errors with --stop-on-errors" do
    input = "</p>\n"
    path = path_to("tmp", "in-place.html")
    write path, input

    status = system("%s --stop-on-errors %s 2>/dev/null" % [command, escape(path)])

    expect(status).to be_falsey
  end

  it "allows a configurable number of consecutive blank lines" do
    input = "<h1>foo</h1>\n\n\n\n\n<p>bar</p>\n"
    expected = "<h1>foo</h1>\n\n\n<p>bar</p>\n"
    path = path_to("tmp", "in-place.html")
    write path, input

    system "%s --keep-blank-lines=2 %s" % [command, escape(path)]

    expect(read(path)).to eq(expected)
  end
end
