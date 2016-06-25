defmodule Curve25519.Mixfile do
  use Mix.Project

  def project do
    [app: :curve25519,
     version: "0.1.1",
     elixir: "~> 1.2",
     name: "Curve25519",
     source_url: "https://github.com/mwmiller/curve25519_ex",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps]
  end

  def application do
    []
  end

  defp deps do
    [
      {:earmark, "~> 0.2", only: :dev},
      {:ex_doc, "~> 0.12", only: :dev},
    ]
  end

  defp description do
    """
    Curve25519 Diffie-Hellman functions
    """
  end

  defp package do
    [
     files: ["lib", "mix.exs", "README*", "LICENSE*", ],
     maintainers: ["Matt Miller"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/mwmiller/curve25519_ex",}
    ]
  end

end
