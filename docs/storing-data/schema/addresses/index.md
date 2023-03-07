---
layout: home
title: Schema - Addresses
heading: Schema - Addresses
description: Schema
---

[< Schema](/storing-data/schema/)

#### `addresses`

| Name | Datatype | Description | Relation |
| ----- | ----- | ----- | ----- |
| id | [integer](https://digital-land.github.io/specification/datatype/integer) | - | -
| full | [string](https://digital-land.github.io/specification/datatype/string) | - | -
| town |[string](https://digital-land.github.io/specification/datatype/string)| - | -
| postcode |[string](https://digital-land.github.io/specification/datatype/string)| - | -
| map_east |[string](https://digital-land.github.io/specification/datatype/string)| Eastings[^1] | -
| map_north |[string](https://digital-land.github.io/specification/datatype/string)| Northings[^1] | -
| created_at | [string](https://digital-land.github.io/specification/datatype/datetime) | - | -
| updated_at | [string](https://digital-land.github.io/specification/datatype/datetime) | - | -
| ward_code |[string](https://digital-land.github.io/specification/datatype/string)| Electoral ward code[^2] | -
| ward_name |[string](https://digital-land.github.io/specification/datatype/string)| Electoral ward name | -
| latitude |[string](https://digital-land.github.io/specification/datatype/string)| Latitude[^3] | -
| longitude |[string](https://digital-land.github.io/specification/datatype/string)| Longitude[^3] | -
| property_id | [integer](https://digital-land.github.io/specification/datatype/integer) | - | properties.id

[^1]: Northings / Eastings / lat lng will be updated as data is ingressed. 
[^2]: [Ward codes are defined by the ONS](https://www.ons.gov.uk/methodology/geography/geographicalproducts/namescodesandlookups)
[^3]: Lat/lng data is stored as is for now, we have not set a format.