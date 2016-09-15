defmodule DomainPartsTest do
  use ExUnit.Case
  doctest DomainParts

  test "an error occurs with an invalid tld" do
    assert "notareal.domainatall" |> DomainParts.new == {:error, :invalid_url}
  end

  test "an error occurs with invalid url" do
    assert "http://fas:fishes.io" |> DomainParts.new == {:error, :invalid_url}
  end

  test "an error occurs with a string that is invalid" do
    assert "fat:fat" |> DomainParts.new == {:error, :invalid_url}
  end

  test "correctly parses valid urls with subdomains" do
    struct = "postgres://asdf:123@somesub.somedomain.co" |> DomainParts.new
    assert struct == %DomainParts{
      subdomain: "somesub",
      domain:    "somedomain",
      tld:       "co",
    }
  end

  test "correctly parses valid urls with multiple subdomains" do
    struct = "ftp://i.love.my.squishy.horse" |> DomainParts.new
    assert struct == %DomainParts{
      subdomain: "i.love.my",
      domain:    "squishy",
      tld:       "horse",
    }
  end

  test "correctly parses valid urls without protocols" do
    struct = "beef.chicken.fish.horse" |> DomainParts.new
    assert struct == %DomainParts{
      subdomain: "beef.chicken",
      domain:    "fish",
      tld:       "horse",
    }
  end

  test "correctly parses compound tlds" do
    struct = "horse.edu.au" |> DomainParts.new
    assert struct == %DomainParts{
      subdomain: "",
      domain:    "horse",
      tld:       "edu.au",
    }
  end

  test "DomainParts struct can be stringify" do
    struct = "postgres://asdf:123@somesub.somedomain.co" |> DomainParts.new
    assert struct == %DomainParts{
      subdomain: "somesub",
      domain:    "somedomain",
      tld:       "co",
    }
    assert struct |> to_string == "somesub.somedomain.co"
  end

end
