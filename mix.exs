defmodule Robert.MixProject do
  use Mix.Project

  def project do
    [
      app: :robert,
      version: "0.1.0",
      elixir: "~> 1.7",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      name: "robert",
      docs: docs(),
      package: package(),
      description: "Automatic process clustering.",
      source_url: "https://github.com/satom99/robert"
    ]
  end

  def application do
    [
      mod: {Robert, []}
    ]
  end

  defp deps do
    [
      {:fastglobal, "~> 1.0"},
      {:ex_hash_ring, "~> 3.0"},
      {:ex_doc, "~> 0.19.2", only: :dev}
    ]
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      maintainers: ["Santiago Tortosa"],
      links: %{"GitHub" => "https://github.com/satom99/robert"}
    ]
  end

  defp docs do
    [
      main: "overview",
      extras: [
        "docs/Overview.md"
      ],
      groups_for_extras: [
        "Introduction": ~r/docs\/.?/
      ]
    ]
  end
end
