defmodule Chirinola.Worker do
    @doc """
    Documentation for `Worker` module.
    """
  
    use GenServer
  
    alias Chirinola.PlantTrait
  
    def start_link(), do: GenServer.start_link(__MODULE__, [])
  
    def insert(pid, element), do: GenServer.cast(pid, {:insert, element})
  
    def insert_all(pid, element), do: GenServer.cast(pid, {:insert_all, element})
  
    @impl true
    def init(stack), do: {:ok, stack}
  
    @impl true
    def handle_cast({:insert, element}, state) do
      PlantTrait.insert(element)
  
      {:noreply, state}
    end
  
    @impl true
    def handle_cast({:insert_all, element}, state) when length(state) < 200 do
      {:noreply, state ++ [element]}
    end
  
    def handle_cast({:insert_all, element}, state) when length(state) == 200 do
      PlantTrait.insert_all(state ++ [element])
  
      {:noreply, []}
    end
  end
  