# Overview

Robert is an automatic process clustering library.

### Installation

Currently there is no package published on Hex and
instead one must include Robert as follows.

```elixir
defp deps do
  [{:robert, git: "https://github.com/satom99/robert.git"}]
end
```

Once installed, be sure to depend on other libraries to
handle node discovery automatically for you.

### Usage

Make sure the local node is connected to the cluster before
Robert is started to prevent any slowdown.

```elixir
defmodule Example do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(:handoff, _from, state) do
    {:stop, :normal, state, state}
  end

  def handle_cast({:handoff, handed}, _state) do
    {:noreply, handed}
  end
end
```

Whenever the cluster topology changes, Robert will shift
processes to the corresponding nodes whilst also handing
off state. A call with the event `:handoff` is sent to
the process on the now-old node, which should return any
piece of data to be handed off as well as possibly stop
the running process. Consequently a cast with the event
`{:handoff, data}` is sent to the process on the new node,
at which stage the shifting is over.
