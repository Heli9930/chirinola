defmodule Chirinola.QueueManager do
    @doc """
    Documentation for `Worker` module.
    """
  
    use GenServer
  
    def start_link(), do: GenServer.start_link(__MODULE__, [])
  
    def push(pid, new_pid), do: GenServer.cast(pid, {:in, new_pid})
  
    def get_pid(pid), do: GenServer.call(pid, :get_pid)
  
    @impl true
    def init(stack), do: {:ok, stack}
  
    @impl true
    def handle_cast({:in, pid}, queue), do: {:noreply, queue ++ [pid]}
  
    @impl true
    def handle_call(:get_pid, _from, [pid | queue]),
      do: {:reply, {:ok, pid}, queue ++ [pid]}
  end
  