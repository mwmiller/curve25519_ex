defmodule Curve25519.Mixfile do
  use Mix.Project

  def project do
    [
      app: :curve25519,
      version: "1.0.1",
      elixir: "~> 1.4",
      name: "Curve25519",
      source_url: "https://github.com/mwmiller/curve25519_ex",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:earmark, "~> 1.0", only: :dev},
      {:ex_doc, "~> 0.14", only: :dev},
      {:credo, "~> 0.8", only: [:dev, :test]}
    ]
  end

  defp description do
    """
    Curve25519 Diffie-Hellman functions
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Matt Miller"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/mwmiller/curve25519_ex"}
    ]
  end
end
