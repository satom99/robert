defmodule Robert.Watcher do
  @moduledoc false

  use Supervisor

  alias Robert.Storage

  def start_link(_state) do
    options = [
      strategy: :one_for_one,
      name: __MODULE__
    ]
    Supervisor.start_link([], options)
  end

  def start_child(name, spec) do
    dest = watcher(name)
    spec = spec
    |> Map.put(:id, name)
    |> Map.put(:restart, :transient)

    Supervisor.start_child(dest, spec)
  end

  def delete_child(name) do
    dest = watcher(name)
    Supervisor.terminate_child(dest, name)
    Supervisor.delete_child(dest, name)
  end

  def whereis(name) do
    watcher(name)
    |> Supervisor.which_children
    |> Enum.find_value(fn
      {^name, pid, _type, _modules} ->
        pid
      _other -> false
    end)
  end

  def migrants do
    __MODULE__
    |> Supervisor.which_children
    |> Enum.filter(fn
      {name, _pid, _type, _modules} ->
        Storage.find(name) != node()
    end)
  end

  def childspec(name) do
    __MODULE__
    |> :supervisor.get_childspec(name)
    |> case do
      {:ok, spec} ->
        spec
      _other -> nil
    end
  end

  defp watcher(name) do
    {__MODULE__, Storage.find(name)}
  end
end
