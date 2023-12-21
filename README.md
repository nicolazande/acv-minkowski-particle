# acv-minkowski-particle

## Description

This algorithm is designed to calculate the Inevitable Collision States (ICS) Set for a vehicle within a given circuit. The purpose of this algorithm is to be executed offline, providing the result that can be utilized to create Virtual Boundaries in the state space. These boundaries will allow the vehicle's driver to maintain full control within them.

## Background

In the context of vehicle navigation on a circuit, the state space represents all possible states in which the vehicle can exist on the track. The Inevitable Collision States (ICS) Set is the collection of states where a collision is unavoidable, given the vehicle's current trajectory and the circuit's constraints.

## How it Works

The algorithm takes into consideration the circuit's layout and the vehicle's dynamic properties to calculate the ICS Set. By analyzing the vehicle's motion model and the circuit's geometry, the algorithm identifies regions where collision is inevitable if the vehicle follows its current trajectory.

https://github.com/nicolazande/acv-minkowski-particle/assets/115359494/0d84f5b2-0426-4b9c-8dd2-f9cd2988a283



## Usage

To use this algorithm, follow these steps:

1. Input the circuit layout and define the vehicle's dynamic properties.
2. Execute the algorithm offline to calculate the ICS Set.
3. Utilize the generated ICS Set to create Virtual Boundaries in the state space.
4. Implement these Virtual Boundaries within the vehicle's control system.

With Virtual Boundaries in place, the vehicle's control system can be designed to prevent the vehicle from entering the ICS regions, ensuring a safe and controlled driving experience.
