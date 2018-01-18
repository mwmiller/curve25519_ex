defmodule Curve25519Test do
  use ExUnit.Case
  doctest Curve25519

  test "PDF example" do
    # From http://cr.yp.to/highspeed/naclcrypto-20090310.pdf, section 6
    # Covers tests in section 3 and 4 by construction
    alicesk =
      <<0x77, 0x07, 0x6D, 0x0A, 0x73, 0x18, 0xA5, 0x7D, 0x3C, 0x16, 0xC1, 0x72, 0x51, 0xB2, 0x66,
        0x45, 0xDF, 0x4C, 0x2F, 0x87, 0xEB, 0xC0, 0x99, 0x2A, 0xB1, 0x77, 0xFB, 0xA5, 0x1D, 0xB9,
        0x2C, 0x2A>>

    alicepk =
      <<0x85, 0x20, 0xF0, 0x09, 0x89, 0x30, 0xA7, 0x54, 0x74, 0x8B, 0x7D, 0xDC, 0xB4, 0x3E, 0xF7,
        0x5A, 0x0D, 0xBF, 0x3A, 0x0D, 0x26, 0x38, 0x1A, 0xF4, 0xEB, 0xA4, 0xA9, 0x8E, 0xAA, 0x9B,
        0x4E, 0x6A>>

    assert Curve25519.derive_public_key(alicesk) == alicepk

    bobsk =
      <<0x5D, 0xAB, 0x08, 0x7E, 0x62, 0x4A, 0x8A, 0x4B, 0x79, 0xE1, 0x7F, 0x8B, 0x83, 0x80, 0x0E,
        0xE6, 0x6F, 0x3B, 0xB1, 0x29, 0x26, 0x18, 0xB6, 0xFD, 0x1C, 0x2F, 0x8B, 0x27, 0xFF, 0x88,
        0xE0, 0xEB>>

    bobpk =
      <<0xDE, 0x9E, 0xDB, 0x7D, 0x7B, 0x7D, 0xC1, 0xB4, 0xD3, 0x5B, 0x61, 0xC2, 0xEC, 0xE4, 0x35,
        0x37, 0x3F, 0x83, 0x43, 0xC8, 0x5B, 0x78, 0x67, 0x4D, 0xAD, 0xFC, 0x7E, 0x14, 0x6F, 0x88,
        0x2B, 0x4F>>

    assert Curve25519.derive_public_key(bobsk) == bobpk

    shared_secret =
      <<0x4A, 0x5D, 0x9D, 0x5B, 0xA4, 0xCE, 0x2D, 0xE1, 0x72, 0x8E, 0x3B, 0xF4, 0x80, 0x35, 0x0F,
        0x25, 0xE0, 0x7E, 0x21, 0xC9, 0x47, 0xD1, 0x9E, 0x33, 0x76, 0xF0, 0x9B, 0x3C, 0x1E, 0x16,
        0x17, 0x42>>

    assert Curve25519.derive_shared_secret(alicesk, bobpk) == shared_secret
    assert Curve25519.derive_shared_secret(bobsk, alicepk) == shared_secret
  end

  test "full cycle" do
    {ask, apk} = Curve25519.generate_key_pair()
    {bsk, bpk} = Curve25519.generate_key_pair()

    assert byte_size(ask) == 32
    assert byte_size(apk) == 32
    assert byte_size(bsk) == 32
    assert byte_size(bpk) == 32

    refute ask == apk
    refute ask == bsk
    refute ask == bpk
    refute apk == bsk
    refute apk == bpk
    refute bsk == bpk

    assert Curve25519.derive_shared_secret(ask, bpk) == Curve25519.derive_shared_secret(bsk, apk)

    refute Curve25519.derive_shared_secret(bpk, ask) == Curve25519.derive_shared_secret(apk, bsk)
  end

  test "improper key sizes" do
    short_key = "too short and not very random"
    long_key = "too long and still not very random"
    proper_key = "just right -- if not very random"

    refute Curve25519.derive_public_key(proper_key) == :error
    assert Curve25519.derive_public_key(short_key) == :error
    assert Curve25519.derive_public_key(long_key) == :error

    refute Curve25519.derive_shared_secret(proper_key, proper_key) == :error
    assert Curve25519.derive_shared_secret(proper_key, long_key) == :error
    assert Curve25519.derive_shared_secret(proper_key, short_key) == :error
    assert Curve25519.derive_shared_secret(long_key, proper_key) == :error
    assert Curve25519.derive_shared_secret(short_key, proper_key) == :error
    assert Curve25519.derive_shared_secret(short_key, long_key) == :error
    assert Curve25519.derive_shared_secret(long_key, short_key) == :error
    assert Curve25519.derive_shared_secret(long_key, long_key) == :error
    assert Curve25519.derive_shared_secret(short_key, short_key) == :error
  end
end
