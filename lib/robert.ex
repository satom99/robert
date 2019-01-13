defmodule Robert do
  use Application

  alias Robert.{Storage, Watcher, Handler}

  @doc false
  def start(_type, _args) do
    children = [
      Storage,
      Watcher,
      Handler
    ]
    options = [
      strategy: :one_for_one,
      name: __MODULE__
    ]
    Supervisor.start_link(children, options)
  end

  @doc """
  Locates a running process in the cluster.
  """
  @spec whereis(term) :: pid | nil

  defdelegate whereis(name), to: Watcher

  @doc """
  Removes a running process from the cluster.
  """
  @spec unregister(term) :: :ok | {:error, term}

  defdelegate unregister(name), to: Watcher, as: :delete_child

  @doc """
  Starts a process with the given spec and registers it under a name.
  """
  @spec register(term, Supervisor.child_spec) :: Supervisor.on_start_child

  defdelegate register(name, spec), to: Watcher, as: :start_child
end
