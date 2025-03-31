+++
title = 'Monitoring Kubernetes Costs with Kubecost'
date = 2023-01-03T00:00:00-06:00
description = 'How to monitor and reduce Kubernetes spend with Kubecost.'
author = 'Nickolas Kraus'
featured = true
draft = false
weight = 1
+++

<p style="text-align: center;">
  <img src="../img/monitoring-kubernetes-costs-with-kubecost/cover.png"/>
</p>

Do you know how much your Kubernetes workloads cost? If you answered "No", do not be dismayed. Based on a [2021 CNCF survey](https://www.cncf.io/wp-content/uploads/2021/06/FINOPS_Kubernetes_Report.pdf), 44% of respondents rely on monthly estimates, while 24% do not monitor Kubernetes spending at all. This, combined with the fact that 68% of respondents reported their Kubernetes-related costs had grown in the past year, has exposed a need for better cost monitoring of applications running on Kubernetes.

Though solutions exist for calculating costs in aggregate (AWS Cost Explorer, GCP Cost Tools, etc.), most companies want fine-grained visibility into the cost distribution of Kubernetes workloads. The open source cost monitoring tool, [Kubecost](https://www.kubecost.com), provides a solution and has seen a steady rise in popularity (13% of respondents currently use Kubecost) due to its ability to accurately report costs at the Kubernetes resource level.

## Kubecost

Kubecost was founded in 2019 with the goal of providing visibility into spend and resource efficiency in Kubernetes environments. It was developed by Kubernetes practitioners with support from the community and contributing partners, including AWS and Google, and currently helps thousands of teams monitor and reduce cloud costs. Kubecost is built on OpenCost, which was accepted as a Cloud Native Computing Foundation (CNCF) Sandbox project in June 2022.

OpenCost, which was open sourced by Kubecost, seeks to develop a common standard around measuring and allocating infrastructure and container costs—enabling teams using Kubernetes to operate with a single cost model across all of their environments. OpenCost aims to be platform-agnostic across all clouds, including on-prem and air-gapped environments.

## OpenCost, Kubecost's Open Core

>OpenCost shines a light into the black box of Kubernetes spend.

[OpenCost](https://www.opencost.io) is a vendor-neutral, open source project for measuring and allocating infrastructure and container costs in Kubernetes environments. It is both a [specification](https://github.com/opencost/opencost/blob/develop/spec/opencost-specv01.md) and [implementation](https://github.com/opencost/opencost). OpenCost constitutes the cost allocation engine for Kubecost, thereby functioning as an "[open core](https://en.wikipedia.org/wiki/Open-core_model)" for the Kubecost product.

### OpenCost Specification Overview

OpenCost defines a methodology for accurately measuring and allocating the costs of a Kubernetes cluster to its hosted tenants. The OpenCost specification builds upon a fundamental equation:

| Total Cluster Costs |  =  | Cluster Asset Costs |  +  | Cluster Overhead Costs |
| :-----------------: | :-: | :-----------------: | :-: | :--------------------: |

* **Total Cluster Costs**: All costs required to operate a Kubernetes cluster.
* **Cluster Assets Costs**: Costs related to directly observable entities within a cluster (nodes, persistent volumes, etc.).
* **Cluster Overhead Costs**: Costs required to operate all of the assets of a cluster.

**Cluster Asset Costs** can be further segmented into **Resource Allocation Costs** and **Resource Usage Costs**.

| Total Cluster Costs |  =  | Resource Allocation Costs |  +  | Resource Usage Costs |  +  | Cluster Overhead Costs |
| :-----------------: | :-: | :-----------------------: | :-: | :------------------: | :-: | :--------------------: |

* **Resource Allocation Costs**: Costs that accumulate based on the amount of time provisioned irrespective of usage (e.g. CPU hourly rate).
* **Resource Usage Costs**: Costs that accumulate on a per-unit basis (e.g. cost per byte egressed).

The cost of an individual asset is the summation of its Resource Allocation Costs and Resource Usage Costs.

**NOTE**: Resource Allocation Costs and Resource Usage Costs are summed for all assets when calculating Total Cluster Costs.

<p style="text-align: center;">
  <img src="../img/monitoring-kubernetes-costs-with-kubecost/img-0.png"/>
</p>

From here, we differentiate between Workload Costs and Cluster Idle Costs:

* **Workload Costs**: Costs that can be directly attributed to a set of Kubernetes workloads (pod, deployment, etc.).
* **Cluster Idle Costs**: Costs that are not allocated to any workload.

| Total Cluster Costs |  =  | Workload Costs |  +  | Cluster Idle Costs |  +  | Cluster Overhead Costs |
| :-----------------: | :-: | :------------: | :-: | :----------------: | :-: | :--------------------: |

<p style="text-align: center;">
  <img src="../img/monitoring-kubernetes-costs-with-kubecost/img-1.png"/>
</p>

**NOTE**: Workload Costs is equal to the summation of Resource Allocation Costs minus Cluster Idle Costs plus Resource Usage Costs. This allows for the disambiguation between the cost of workloads and the cost of provisioned infrastructure.

| Workload Costs |  =  | Resource Allocation Costs |  –  | Cluster Idle Costs |  +  | Resource Usage Costs |
| :------------: | :-: | :-----------------------: | :-: | :----------------: | :-: | :------------------: |

Likewise, Cluster Idle Costs can be calculated as:

| Cluster Idle Costs |  =  | Cluster Asset Costs |  –  | Workload Costs |
| :----------------: | :-: | :-----------------: | :-: | :------------: |

<p style="text-align: center;">
  <img src="../img/monitoring-kubernetes-costs-with-kubecost/img-2.png"/>
</p>

Not only does this provide a means for directly calculating the cost of a Kubernetes workload, but with data gathered from billing APIs, the idle cost of a cluster can be determined. To ensure maximum efficiency of a cluster, idle costs should be minimized.

For the full specification, see the [OpenCost Specification](https://github.com/opencost/opencost/blob/develop/spec/opencost-specv01.md).

## Kubecost vs. OpenCost

The OpenCost implementation is the cost allocation engine originally built by Kubecost. This implementation is actively used in all versions of Kubecost for building a cost allocation model.

It should be noted that both Kubecost and OpenCost can be used freely under certain conditions. See the Kubecost [product comparison](https://docs.kubecost.com/general/opencost-product-comparison) documentation for more details.

## Cost Reduction with Kubecost

Kubecost can provide insights into overspend by allowing the actual cost of running a Kubernetes workload to be compared with the cost of its hosted tenants. For example, let's say I am renting a 10-bedroom, 10,000 sq. ft. mansion for me and my pet iguana, Iggy. If I have my own room and Iggy has his own room, there are still 8 other bedrooms left vacant for which I am still paying. This is a classic case of overspend. The remaining 8 bedrooms are considered *idle* costs of maintaining my profligate lifestyle. Likewise, an overprovisioned cluster will have high idle costs. As the idle percentage of a cluster increases, the efficiency decreases, representing a cost savings opportunity. Iggy and I would suffice with a 1-bedroom, 500 sq. ft. studio apartment. Similarly, an overprovisioned Kubernetes cluster would suffice with a smaller node instance.

## OpenCost Installation

OpenCost can be installed via Helm using a Helm chart maintained by Infrable:
* [infrable-io/k8s-opencost](https://github.com/infrable-io/k8s-opencost)

Or by using their [installation guide](https://www.opencost.io/docs/install).

The OpenCost documentation can be found [here](https://www.opencost.io/docs).

## Kubecost Installation

Kubecost can be installed via Helm using the official Helm chart maintained by Kubecost:
* [kubecost/cost-analyzer-helm-chart](https://github.com/kubecost/cost-analyzer-helm-chart)

Or by using their [installation guide](https://docs.kubecost.com/install-and-configure/install).

The Kubecost documentation can be found [here](https://docs.kubecost.com).

## Conclusion

Companies should go beyond basic cost estimations, since this approach offers little insight into actionable steps for reducing cost and increasing efficiency. Instead, they should leverage a product such as Kubecost for accurate cost allocation of Kubernetes workloads. Combining real-time Kubernetes cluster costs with a robust pattern of tagging external resources (database instances, object storage, etc.) provides a unified view of spend, allowing cost attribution at the team/organization level, accurate budgeting and cost projections, real-time mitigation of runaway spend, and optimized resource utilization.
