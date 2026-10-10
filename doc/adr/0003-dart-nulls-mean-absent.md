# 3. Dart's nulls in argument maps mean absent

Date: 10.10.2026

## Status

Accepted. Ships with 1.0.0.

## Context

Dart models send their `map`, which holds every key, `null` for unset fields. HealthConnectReporter encodes its JSON with `explicitNulls = false`, so an unset field has no key, and some properties with defaults are not nullable, e.g. `TimeGroup.Period.zoneId` (the device's zone by default). Decoding `null` into such a property fails.

## Decision

Kotlin drops the null values of every argument map, nested maps and lists included, before it reads a payload with `make(from:)` or decodes a sealed model (`Permission`, `TimeGroup`) with kotlinx.serialization. A missing key and a null key mean the same: the property takes its default.

## Consequences

- Dart can model library defaults as nullable fields (`zoneId`) and keep sending complete maps.
- Dart models keep writing every key, so `map` stays stable for equality, and tests compare a model's `map` without its nulls to the library's JSON.
