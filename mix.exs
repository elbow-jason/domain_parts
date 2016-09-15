defmodule DomainParts.Mixfile do
  use Mix.Project

  def project do
    [
      app: :domain_parts,
      version: "0.1.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: description,
      package: package,
      deps: deps,
    ]
  end

  defp apps do
    [
     :logger,
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: apps
    ]
  end

  defp description do
    """
    A module for extracting the parts of a domain (subdomain, domain, and tld).
    """
  end

  defp package do
    [
       name: :domain_parts,
       files: ["lib", "mix.exs", "README*", "LICENSE*"],
       maintainers: ["Jason Goldberger"],
       licenses: ["MIT"],
       links: %{"GitHub" => "https://github.com/elbow-jason/domain_parts"}
    ]
   end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:public_suffex,  github: "captainhurst/public_suffex"},
    ]
  end
end
