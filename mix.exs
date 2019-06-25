defmodule Monad.MixProject do
  use Mix.Project

  def project do
    [
      app: :monad,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # Docs
      docs: [
        main: "Monoid",
        extras: ["README.md"],
        groups_for_functions: [
          Callbacks: & &1[:callback]
        ],
        groups_for_modules: [
          Behaviours: [
            FunctorBehaviour,
            MonadBehaviour,
            MonoidBehaviour,
            SemigroupBehaviour
          ],
          "Category Theory": [
            Functor,
            Monad,
            Monoid
          ],
          "Custom Data Type": [
            Item
          ],
          Functors: [
            ListFunctor,
            OKFunctor,
            StringFunctor
          ],
          Monads: [
            ListMonad,
            OKMonad
          ],
          Monoids: [
            AdditionMonoid,
            ListMonoid,
            StringMonoid,
            StructMonoid
          ]
        ]
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
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:ok, "~> 2.2"}
    ]
  end
end
