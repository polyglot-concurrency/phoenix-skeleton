defmodule Api.MixProject do
  use Mix.Project

  @version "0.1.0"
  @app_name :api

  def project do
    [
      app: @app_name,
      version: @version,
      elixir: System.get_env("ELIXIR_VERSION"),
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Dialyzer
      dialyzer: dialyzer(),

      # Releases
      releases: releases(),
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Api.Application, []},
      extra_applications: [
        :logger, :runtime_tools, :jason, :logger_json,
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, System.get_env("PHOENIX_VERSION")},
      {:phoenix_pubsub, System.get_env("PHOENIX_PUBSUB_VERSION")},
      {:gettext, System.get_env("GETTEXT_VERSION")},
      {:jason, System.get_env("JASON_VERSION")},
      {:plug_cowboy, System.get_env("PLUG_COWBOY_VERSION")},
      {:dns, System.get_env("DNS_VERSION")},
      {:libcluster, path: "../../infrastructure/libcluster"},

      # Code Analysis
      {:dialyxir, System.get_env("DIALYXIR_VERSION"), only: [:dev], runtime: false},
      {:credo, System.get_env("CREDO_VERSION"), only: [:dev, :test]},

      # Test
      {:excoveralls, System.get_env("EXCOVERALLS_VERSION"), only: :test},
      {:mock, System.get_env("MOCK_VERSION"), only: :test},
      {:mox, System.get_env("MOX_VERSION"), only: :test},

      {:observer_cli, System.get_env("OBSERVER_CLI")},

      {:logger_json, System.get_env("LOGGER_JSON")},

    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [:ecto, :mix, :eex, :mnesia],
      ignore_warnings: "dialyzer.ignore-warnings",
      flags: [
        :unmatched_returns,
        :error_handling,
        :race_conditions,
        :no_opaque,
        :unknown,
        :no_return,
      ],
    ]
  end

  defp release_version(nil), do: @version
  defp release_version(suffix), do: @version <> "-" <> suffix

  defp copy_extra_files(rel) do

    File.copy!("cli/cfg_files/erl_inetrc", "#{rel.path}/releases/erl_inetrc")

    File.copy!(
      "config/prod.exs",
      "#{rel.path}/releases/#{release_version(System.get_env("RELEASE_TAR_NAME_SUFFIX"))}/releases.exs"
    )
    rel
  end

  defp releases() do
    [
      api: [
        version: release_version(System.get_env("RELEASE_TAR_NAME_SUFFIX")),
        steps: [:assemble, &copy_extra_files/1, :tar],
        path: "cli/devOps/files/app/build/#{to_string(@app_name)}", # Defaults to "_build/MIX_ENV/rel/RELEASE_NAME"
        include_executables_for: [:unix],
        applications: [
          runtime_tools: :permanent,
          mnesia: :permanent,
        ],
      ],
    ]
  end
end
