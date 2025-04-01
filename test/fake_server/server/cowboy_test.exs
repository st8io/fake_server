defmodule FakeServer.CowboyTest do
  use ExUnit.Case, async: true

  alias FakeServer.Cowboy
  alias FakeServer.Instance

  describe "#start_listen" do
    test "starts an http server on the port provided by the Instance configuration" do
      instance = %Instance{port: 55000}
      assert {:ok, _pid} = Cowboy.start_listen(instance)
      assert {:error, :eaddrinuse} = :gen_tcp.listen(55000, ip: {0, 0, 0, 0})
      :cowboy.stop_listener(instance.server_name)
    end

    test "starts an http server with the given server_name" do
      instance = %Instance{port: 55000, server_name: :test_server}
      assert {:ok, _pid} = Cowboy.start_listen(instance)
      assert :ok == :cowboy.stop_listener(:test_server)
    end
  end

  describe "#stop" do
    test "stops a given started instance" do
      instance = %Instance{port: 55000, server_name: :test_server}
      assert {:ok, _pid} = Cowboy.start_listen(instance)
      assert {:error, :eaddrinuse} = :gen_tcp.listen(55000, ip: {0, 0, 0, 0})
      assert :ok = Cowboy.stop(instance)
      assert {:ok, socket} = :gen_tcp.listen(55000, ip: {0, 0, 0, 0})
      :gen_tcp.close(socket)
    end
  end
end
