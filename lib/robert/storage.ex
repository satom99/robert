defmodule Robert.Storage do
  @moduledoc false

  use GenServer

  alias ExHashRing.HashRing

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(_state) do
    nodes = Node.list() ++ [node()]
    ring = HashRing.new(nodes, 128)
    FastGlobal.put(__MODULE__, ring)
    :ignore
  end

  def find(key) do
    HashRing.find_node(fetch(), key)
  end

  def add_node(node) do
    update(:add_node, node)
  end

  def remove_node(node) do
    update(:remove_node, node)
  end

  defp update(method, node) do
    params = [fetch(), node]
    {:ok, ring} = apply(HashRing, method, params)
    FastGlobal.put(__MODULE__, ring)
  end

  defp fetch do
    FastGlobal.get(__MODULE__)
  end
end
