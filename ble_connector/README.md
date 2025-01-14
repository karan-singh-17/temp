# Ble Connector Package
The **Ble Connector** is a package that enables higher level access to bluetooth functions.

The `BleWrapper` is a lower level wrapper around bluetooth functions. 

The `BleConnector` is a facade that ensures everything created uses the same `BleWrapper` to ensure consistency across the project

The `BleDevice` and its variants like `BleDemoDevice` each represent a device that can be connected to.

The `BleDiscovery` represents a mechanism to discover `BleDevice`s.
