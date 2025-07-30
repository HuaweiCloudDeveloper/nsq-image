<p align="center">
  <h1 align="center">NSQ Real-time Distributed Messaging Platform</h1>
  <p align="center">
    <a href="README.md"><strong>English</strong></a> | <strong>简体中文</strong>
  </p>
</p>

## Table of Contents

- [Repository Introduction](#repository-introduction)
- [Prerequisites](#prerequisites)
- [Image Specifications](#image-specifications)
- [Getting Help](#getting-help)
- [How to Contribute](#how-to-contribute)

## Repository Introduction
‌[NSQ‌](https://github.com/nsqio/nsq) NSQ is a real-time distributed messaging platform open-sourced by Bitly, designed for high-throughput, low-latency large-scale message processing. It features lightweight, easy deployment, and high availability, making it suitable for microservices architecture, real-time data processing, event-driven systems, and other scenarios.

**Core Features:**
1. Distributed Message Queue Architecture: NSQ adopts a decentralized distributed design with no single point of failure. Messages are logically separated through topics and channels, supporting multiple consumer groups (multiple channels subscribing to the same topic) to achieve message broadcasting or load balancing.
2. Horizontal Scaling and High Availability: Supports dynamic addition of nsqd (message processing nodes) and nsqlookupd (service discovery nodes) without downtime for expansion. Messages are persisted to disk by default, ensuring data is not lost even if nodes restart.
3. Real-time Message Delivery: Uses a push mode for real-time message delivery with low latency (millisecond level). Consumers subscribe to messages via TCP long connections, supporting automatic reconnection and message timeout mechanisms to ensure real-time performance.
4. No Single Point Dependency: Does not rely on external coordination services like ZooKeeper or etcd, featuring a lightweight design. nsqlookupd only provides service discovery, and its failure does not affect communication between existing nsqd and consumers.
5. Message Reliability Assurance: Supports a message acknowledgment (ACK) mechanism, where consumers must explicitly ACK after successful processing; otherwise, the message is requeued. Provides a maximum retry count configuration to avoid infinite loops in processing failed messages.
6. Simple and Easy-to-Integrate Protocol: Based on HTTP/JSON API management interfaces, with messages transmitted via TCP protocol. Clients support multiple languages (Go, Python, Java, etc.), with transparent protocol documentation for easy secondary development.
7. Hybrid Memory and Disk Storage: Messages are preferentially written to in-memory queues (high throughput), automatically switching to disk storage (high reliability) when the memory threshold is exceeded. Supports configuration of in-memory queue size and disk storage policies.
8. Flexible Message Format: Does not enforce message format constraints, supporting any binary data (such as JSON, Protocol Buffers, etc.). Producers and consumers negotiate their own encoding and decoding methods.
9. Dynamic Topology Discovery: Consumers query the list of available nsqd nodes through nsqlookupd, automatically sensing cluster changes (such as new nodes or node failures) to achieve dynamic load balancing.
10. Lightweight and Low Resource Consumption: A single nsqd instance requires only minimal CPU and memory resources (approximately 10MB memory under default configuration), making it suitable for containerized deployment and edge computing scenarios.

This project offers pre-configured [**`NSQ-Real-time Distributed Messaging Platform`**]()，images with NSQ and its runtime environment pre-installed, along with deployment templates. Follow the guide to enjoy an "out-of-the-box" experience.

**Architecture Design:**

![](./images/img.png)

> **System Requirements:**
> - CPU: 4vCPUs or higher
> - RAM: 16GB or more
> - Disk: At least 50GB

## Prerequisites
[Register a Huawei account and activate Huawei Cloud](https://support.huaweicloud.com/usermanual-account/account_id_001.html)

## Image Specifications

| Image Version          | Description | Notes |
|------------------------| --- | --- |
| [NSQ1.3.0-kunpeng-v1.0](https://github.com/HuaweiCloudDeveloper/nsq-image/tree/NSQ1.3.0-kunpeng-v1.0?tab=readme-ov-file) | Deployed on Kunpeng servers with Huawei Cloud EulerOS 2.0 64bit |  |

## Getting Help
- Submit an [issue](https://github.com/HuaweiCloudDeveloper/nsq-image/issues)
- Contact Huawei Cloud Marketplace product support

## How to Contribute
- Fork this repository and submit a merge request.
- Update README.md synchronously based on your open-source mirror information.