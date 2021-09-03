defmodule AdventureTimeOnline.Heroes do
  def subscribe do
    Phoenix.PubSub.subscribe(AdventureTimeOnline.PubSub, "heroes")
  end
end
