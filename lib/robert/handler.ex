defmodule Robert.Handler do
  @moduledoc false

  use GenServer

  alias Robert.{Storage, Watcher}

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(state) do
    :net_kernel.monitor_nodes(true)
    {:ok, state}
  end

  def handle_info({:nodeup, node}, state) do
    Storage.add_node(node)
    Enum.each(Watcher.migrants(), &migrate/1)
    {:noreply, state}
  end

  def handle_info({:nodedown, node}, state) do
    Storage.remove_node(node)
    {:noreply, state}
  end

  defp migrate({name, pid, _type, _modules}) do
    spec = Watcher.childspec(name)
    case Watcher.start_child(name, spec) do
      {:ok, new} ->
        state = GenServer.call(pid, :handoff)
        GenServer.cast(new, {:handoff, state})
      _other -> :ignore
    end
  end
end
