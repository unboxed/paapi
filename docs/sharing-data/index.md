---
layout: home
title: Sharing data
heading: Sharing data
description: Sharing data
---

## Datasets

We identified different systems that provide, create, or read planning data, and systems that use planning data.

### Source data

These systems provide source data:
 - Local Authority Gazetteer
 - Digital Land Planning Data Platform
 - Local Authority GIS


### Create data

These systems create planning application data:

- PlanX
- Planning Portal

### Process data

These process planning application data:

 - BoPS
 - Other back office system
 - Consultee System
 - Consultee Portal
 - ODP Register

### Generated from data

- Central government reports
- Other data users

-------------

## Data strategies

We examined potential data strategies for systems to share data. We concluded on a hybrid stategy, detailed below.

<div class="govuk-accordion" data-module="govuk-accordion" id="accordion-default">
  <div class="govuk-accordion__section">
    <div class="govuk-accordion__section-header">
      <h2 class="govuk-accordion__section-heading">
        <span class="govuk-accordion__section-button" id="accordion-default-heading-1">
          Centralised data storage
        </span>
      </h2>
    </div>
    <div id="accordion-default-content-1" class="govuk-accordion__section-content" aria-labelledby="accordion-default-heading-1">
      
A centralised data store would give the benefit of one point of truth. Data would flow from external
systems to a central database.

<img src="/assets/images/centralised_data_store.svg" alt="Centralised data store">
    </div>
  </div>
  <div class="govuk-accordion__section">
    <div class="govuk-accordion__section-header">
      <h2 class="govuk-accordion__section-heading">
        <span class="govuk-accordion__section-button" id="accordion-default-heading-2">
          Individual system data storage
        </span>
      </h2>
    </div>
    <div id="accordion-default-content-2" class="govuk-accordion__section-content" aria-labelledby="accordion-default-heading-2">
      Each system stores data in a format unique to its system, and data transfer would be agreed between 
      systems and vendors.

      <img src="/assets/images/individual_data_store.svg" alt="Individual data store">
    </div>
  </div>
  <div class="govuk-accordion__section">
    <div class="govuk-accordion__section-header">
      <h2 class="govuk-accordion__section-heading">
        <span class="govuk-accordion__section-button" id="accordion-default-heading-3">
          Proposal: hybrid strategy
        </span>
      </h2>
    </div>
    <div id="accordion-default-content-3" class="govuk-accordion__section-content" aria-labelledby="accordion-default-heading-3">
      An open API standard for planning application information data exchange. Suppliers would send data and pull data to and from endpoints.

      <img src="/assets/images/hybrid_data_store.svg" alt="Hybrid data store">
    </div>
  </div>
</div>

## Data volume and replication latency

It is a challenge in distributed systems where multiple databases are used to store and access data, especially in real-time applications where data consistency and availability are critical. 

Replication latency is the amount of time after an update is made for it to be replicated across all systems.

Most councils use one system to record planning applications, and as such any data strategy would have to examine data transfer issues around this. A conventional nightly batch update would likely meet this issue, with systems having a known 24 hour period of latency. As an API develops, this could be lowered using push techniques.

An API would therefore have to send and recieve 'diffs', or just send changes to data, between start and end times, in order to not overload any nightly tasks.

The largest amount of data transferred would be documents attached to planning data. These would likely be transferred between systems using signed URLs.

## Service level agreements

In adopting a common API, service level agreements would likely be entered into between vendors. This would detail rate limits, latency agreements, and response times.

## Adoption

By proposing an API based approach, we hope to help vendors adopt such a scheme ahead of legislation.
