defmodule Livebook.Runtime.Definitions do
  @moduledoc false

  kino = %{
    name: "kino",
    dependency: %{dep: {:kino, "~> 0.9.3"}, config: []}
  }

  kino_vega_lite = %{
    name: "kino_vega_lite",
    dependency: %{dep: {:kino_vega_lite, "~> 0.1.7"}, config: []}
  }

  kino_db = %{
    name: "kino_db",
    dependency: %{dep: {:kino_db, "~> 0.2.1"}, config: []}
  }

  kino_maplibre = %{
    name: "kino_maplibre",
    dependency: %{dep: {:kino_maplibre, "~> 0.1.7"}, config: []}
  }

  kino_slack = %{
    name: "kino_slack",
    dependency: %{dep: {:kino_slack, "~> 0.1.1"}, config: []}
  }

  kino_bumblebee = %{
    name: "kino_bumblebee",
    dependency: %{dep: {:kino_bumblebee, "~> 0.3.0"}, config: []}
  }

  exla = %{
    name: "exla",
    dependency: %{dep: {:exla, "~> 0.5.1"}, config: [nx: [default_backend: EXLA.Backend]]}
  }

  torchx = %{
    name: "torchx",
    dependency: %{dep: {:torchx, "~> 0.5.1"}, config: [nx: [default_backend: Torchx.Backend]]}
  }

  kino_explorer = %{
    name: "kino_explorer",
    dependency: %{dep: {:kino_explorer, "~> 0.1.4"}, config: []}
  }

  windows? = match?({:win32, _}, :os.type())
  nx_backend_package = if(windows?, do: torchx, else: exla)

  @smart_cell_definitions [
    %{
      kind: "Elixir.KinoDB.ConnectionCell",
      name: "Database connection",
      requirement_presets: [
        %{
          name: "Amazon Athena",
          packages: [
            kino_db,
            %{
              name: "req_athena",
              dependency: %{dep: {:req_athena, "~> 0.1.3"}, config: []}
            }
          ]
        },
        %{
          name: "Google BigQuery",
          packages: [
            kino_db,
            %{
              name: "req_bigquery",
              dependency: %{dep: {:req_bigquery, "~> 0.1.1"}, config: []}
            }
          ]
        },
        %{
          name: "MySQL",
          packages: [
            kino_db,
            %{name: "myxql", dependency: %{dep: {:myxql, "~> 0.6.2"}, config: []}}
          ]
        },
        %{
          name: "PostgreSQL",
          packages: [
            kino_db,
            %{name: "postgrex", dependency: %{dep: {:postgrex, "~> 0.16.3"}, config: []}}
          ]
        },
        %{
          name: "SQLite",
          packages: [
            kino_db,
            %{name: "exqlite", dependency: %{dep: {:exqlite, "~> 0.11.0"}, config: []}}
          ]
        }
      ]
    },
    %{
      kind: "Elixir.KinoDB.SQLCell",
      name: "SQL query",
      requirement_presets: [
        %{
          name: "Default",
          packages: [kino_db]
        }
      ]
    },
    %{
      kind: "Elixir.KinoVegaLite.ChartCell",
      name: "Chart",
      requirement_presets: [
        %{
          name: "Default",
          packages: [kino_vega_lite]
        }
      ]
    },
    %{
      kind: "Elixir.KinoMapLibre.MapCell",
      name: "Map",
      requirement_presets: [
        %{
          name: "Default",
          packages: [kino_maplibre]
        }
      ]
    },
    %{
      kind: "Elixir.KinoSlack.MessageCell",
      name: "Slack message",
      requirement_presets: [
        %{
          name: "Default",
          packages: [kino_slack]
        }
      ]
    },
    %{
      kind: "Elixir.KinoBumblebee.TaskCell",
      name: "Neural Network task",
      requirement_presets: [
        %{
          name: "Default",
          packages: [kino_bumblebee, nx_backend_package]
        }
      ]
    },
    %{
      kind: "Elixir.KinoExplorer.DataTransformCell",
      name: "Data transform",
      requirement_presets: [
        %{
          name: "Default",
          packages: [kino_explorer]
        }
      ]
    }
  ]

  @code_block_definitions [
    %{
      name: "Form",
      icon: "bill-line",
      variants: [
        %{
          name: "Default",
          source: """
          form =
            Kino.Control.form(
              [
                name: Kino.Input.text("Name")
              ],
              submit: "Submit"
            )

          Kino.listen(form, fn event ->
            IO.inspect(event)
          end)

          form\
          """,
          packages: [kino]
        }
      ]
    }
  ]

  def smart_cell_definitions(), do: @smart_cell_definitions

  def code_block_definitions(), do: @code_block_definitions
end
