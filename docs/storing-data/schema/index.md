---
layout: home
title: Schema
heading: Schema
description: Schema
---


We are opening up our intended database schema to try to capture all of the relevant available historical and related data. Please note we have not included document metadata or planning conditions and their relations - we are working on including this. We are welcoming comments on this schema on the ODP slack channel [#group-planning-register-data](https://opendigitalplanning.slack.com/archives/C04MB9HA6N6) or [via email](mailto:bops.register.feedback@unboxed.co).

#### `addresses`

| Name | Type | Description | Relation |
| ----- | ----- | ----- | ----- |
| id | bigint | - | -
| full | string | - | -
| town | string | - | -
| postcode | string | - | -
| map_east | string | Eastings[^1] | -
| map_north | string | Northings[^1] | -
| created_at | datetime | - | -
| updated_at | datetime | - | -
| ward_code | string | Electoral ward code[^2] | -
| ward_name | string | Electoral ward name | -
| latitude | string | Latitude[^3] | -
| longitude | string | Longitude[^3] | -
| property_id | bigint | - | properties.id

[^1]: Northings / Eastings / lat lng will be updated as data is ingressed. 
[^2]: [Ward codes are defined by the ONS](https://www.ons.gov.uk/methodology/geography/geographicalproducts/namescodesandlookups)
[^3]: Lat/lng data is stored as is for now, we have not set a format for now.

#### `local_authorities`

| Name | Type |
| ----- | ----- 
| id | bigint |
| name | string |
| created_at | datetime |
| updated_at | datetime |

#### `planning_applications`

| Name | Type |  Relation
| ----- | ----- | ----- | 
| id | bigint | -
| reference | string | -
| area | string | -
| description | string | -
| received_at | datetime | -
| created_at | datetime | -
| updated_at | datetime | -
| assessor | string | -
| decision | string | -
| decision_issued_at | datetime | -
| local_authority_id | bigint | local_authorities.id
| view_documents | string | -
| application_type | string | -
| reviewer | string | -
| validated_at | datetime | -
| created_at | datetime | -
| updated_at | datetime | -
| view_documents | string | -
| application_type_code | string | -

#### `planning_applications_properties`

| Name | Type | Relation |
| ----- | ----- | ----- |
| id | bigint | -
| planning_application_id | bigint | planning_applications.id
| property_id | bigint | properties.id
| created_at | datetime | -
| updated_at | datetime | -

#### `properties`

| Name | Type | Description |
| ----- | ----- | ----- |
| id | bigint | -
| uprn | string | Universal property reference number [^4]
| type | string | -
| code | string | -
| created_at | datetime | -
| updated_at | datetime | -

[^4]: [Identifying property and street information](https://www.gov.uk/government/publications/open-standards-for-government/identifying-property-and-street-information)

