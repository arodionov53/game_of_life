defmodule GameOfLife.RLETest do
  use ExUnit.Case, async: true

  alias GameOfLife.RLE

  describe "parse_string/1 - cell data" do
    test "simple glider pattern" do
      input = """
      #N Glider
      x = 3, y = 3
      bo$2bo$3o!
      """

      assert {:ok, %{cells: cells}} = RLE.parse_string(input)
      assert cells == MapSet.new([{1, 0}, {2, 1}, {0, 2}, {1, 2}, {2, 2}])
    end

    test "run-length prefix" do
      input = """
      #N Three
      x = 3, y = 1
      3o!
      """

      assert {:ok, %{cells: cells}} = RLE.parse_string(input)
      assert cells == MapSet.new([{0, 0}, {1, 0}, {2, 0}])
    end

    test "multi-row pattern" do
      input = """
      #N Vertical
      x = 1, y = 3
      o$o$o!
      """

      assert {:ok, %{cells: cells}} = RLE.parse_string(input)
      assert cells == MapSet.new([{0, 0}, {0, 1}, {0, 2}])
    end
  end

  describe "parse_string/1 - header" do
    test "standard header with dimensions" do
      input = """
      x = 3, y = 3
      bo$2bo$3o!
      """

      assert {:ok, %{metadata: meta}} = RLE.parse_string(input)
      assert meta.width == 3
      assert meta.height == 3
    end

    test "header with extra spacing" do
      input = """
      x =  10 , y =  5
      o!
      """

      assert {:ok, %{metadata: meta}} = RLE.parse_string(input)
      assert meta.width == 10
      assert meta.height == 5
    end
  end

  describe "parse_string/1 - comments" do
    test "name comment" do
      input = """
      #N Glider
      x = 3, y = 3
      bo$2bo$3o!
      """

      assert {:ok, %{metadata: meta}} = RLE.parse_string(input)
      assert meta.name == "Glider"
    end

    test "comment lines do not affect cell parsing" do
      input = """
      #N Test
      #C This is a comment
      #C Another comment
      x = 3, y = 1
      3o!
      """

      assert {:ok, %{cells: cells}} = RLE.parse_string(input)
      assert cells == MapSet.new([{0, 0}, {1, 0}, {2, 0}])
    end
  end

  describe "parse_string/1 - whitespace tolerance" do
    test "line-wrapped RLE data" do
      # Same glider but with data split across lines
      input = """
      #N Glider
      x = 3, y = 3
      bo$2bo$
      3o!
      """

      assert {:ok, %{cells: cells}} = RLE.parse_string(input)
      assert cells == MapSet.new([{1, 0}, {2, 1}, {0, 2}, {1, 2}, {2, 2}])
    end

    test "data with spaces and tabs" do
      input = """
      #N Test
      x = 3, y = 1
      3o !
      """

      assert {:ok, %{cells: cells}} = RLE.parse_string(input)
      assert cells == MapSet.new([{0, 0}, {1, 0}, {2, 0}])
    end
  end

  describe "parse_string/1 - error handling" do
    test "missing header and data" do
      assert {:error, _} = RLE.parse_string("")
    end

    test "invalid header" do
      input = """
      not a valid header
      """

      assert {:error, msg} = RLE.parse_string(input)
      assert msg =~ "invalid header"
    end

    test "unexpected characters in data" do
      input = """
      x = 3, y = 1
      xyz!
      """

      assert {:error, _} = RLE.parse_string(input)
    end
  end

  describe "parse_file/1" do
    test "valid file" do
      path = Path.join(System.tmp_dir!(), "test_pattern.rle")

      File.write!(path, """
      #N Test
      x = 3, y = 1
      3o!
      """)

      assert {:ok, %{cells: cells, metadata: meta}} = RLE.parse_file(path)
      assert meta.name == "Test"
      assert MapSet.size(cells) == 3

      File.rm!(path)
    end

    test "missing file" do
      assert {:error, :file_not_found} = RLE.parse_file("/nonexistent/path/file.rle")
    end
  end
end
