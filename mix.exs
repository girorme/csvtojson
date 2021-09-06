defmodule Csvtojson.MixProject do
  use Mix.Project

  def project do
    [
      app: :csvtojson,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [
        main_module: Csvtojson,
        comment: "Csv to json",
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 5.0"}
    ]
  end
end
