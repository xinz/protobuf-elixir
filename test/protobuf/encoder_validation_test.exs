Code.require_file("../support/test_msg.ex", __DIR__)

defmodule Protobuf.EncoderTest.Validation do
  use ExUnit.Case, async: true

  import Protobuf.Encoder

  @valid_vals %{
    int32: -32,
    int64: -64,
    uint32: 32,
    uint64: 64,
    sint32: 32,
    sint64: 64,
    bool: true,
    enum: 3,
    fixed64: 164,
    sfixed64: 264,
    double: 2.23,
    bytes: <<1, 2, 3>>,
    string: "str",
    fixed32: 132,
    sfixed32: 232,
    float: 1.23,
    nil: nil
  }

  def other_types(white_list) do
    keys = List.wrap(white_list)

    @valid_vals |> Map.take(keys) |> Map.values()
  end

  test "encode_type/2 is invalid" do
    assert_invalid = fn type, others ->
      Enum.each(other_types(others), fn {invalid, err_type} ->
        assert_raise err_type, fn ->
          encode_type(type, invalid)
        end
      end)
    end

    int_list = [
      bool: ArgumentError,
      double: ArithmeticError,
      bytes: ArgumentError,
      string: ArgumentError,
      float: ArithmeticError,
      nil: ArgumentError
    ]

    assert_invalid.(:int32, int_list)
    assert_invalid.(:int64, int_list)
    assert_invalid.(:uint32, int_list)
    assert_invalid.(:uint64, int_list)
    assert_invalid.(:sint32, int_list)
    assert_invalid.(:sint64, int_list)
    assert_invalid.(:enum, int_list)
    assert_invalid.(:fixed64, int_list)
    assert_invalid.(:sfixed64, int_list)
    assert_invalid.(:fixed32, int_list)
    assert_invalid.(:fixed64, int_list)

    float_list = [
      bool: ArgumentError,
      bytes: ArgumentError,
      string: ArgumentError,
      nil: ArgumentError
    ]

    assert_invalid.(:double, float_list)
    assert_invalid.(:float, float_list)

    bytes_list = [
      int32: ArgumentError,
      bool: ArgumentError,
      double: ArgumentError,
      nil: ArgumentError
    ]

    assert_invalid.(:bytes, bytes_list)
    assert_invalid.(:string, bytes_list)
  end
end