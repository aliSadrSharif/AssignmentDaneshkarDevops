# Kubernetes Cluster Components

## 1. API Server

**Location:** Control Plane

**Role:** The API Server is the main entry point to the Kubernetes cluster. It receives and processes requests from clients such as `kubectl` and other Kubernetes components, and provides access to the Kubernetes API.

---

## 2. etcd

**Location:** Control Plane

**Role:** `etcd` is the key-value data store used by Kubernetes to store the cluster's state and configuration. It contains important information about resources such as Pods, Deployments, Services, and Nodes.

---

## 3. Scheduler

**Location:** Control Plane

**Role:** The Scheduler determines which Node should run a newly created Pod. It evaluates available Nodes and selects a suitable one based on resource requirements and scheduling constraints.

The Scheduler selects the Node, but the actual execution of the Pod is handled by the kubelet on that Node.

---

## 4. Controller Manager

**Location:** Control Plane

**Role:** The Controller Manager runs controllers that continuously monitor the cluster and work to make the current state match the desired state defined by the user.

For example, if a Deployment requires 3 replicas but only 2 are running, controllers can detect the difference and initiate the creation of another Pod.

---

## 5. kubelet

**Location:** Node

**Role:** The kubelet is the main Kubernetes agent running on each Node. It communicates with the Control Plane and ensures that the containers described by assigned Pods are running and healthy.

The kubelet receives the Pod assignment and works with the container runtime to run the required containers.

---

## 6. kube-proxy

**Location:** Node

**Role:** kube-proxy is a networking component that helps implement Kubernetes Service networking. It maintains network rules that allow traffic to be directed to the appropriate backend Pods.

---

## 7. Container Runtime

**Location:** Node

**Role:** The Container Runtime is responsible for actually running containers on a Node. Kubernetes communicates with the runtime through the container runtime interface.

Examples of container runtimes include containerd and CRI-O.

---

## Summary

| Component | Location | Main Responsibility |
|---|---|---|
| API Server | Control Plane | Entry point for Kubernetes API requests |
| etcd | Control Plane | Stores cluster state and configuration |
| Scheduler | Control Plane | Selects a suitable Node for Pods |
| Controller Manager | Control Plane | Maintains the desired cluster state |
| kubelet | Node | Ensures assigned Pods and containers are running |
| kube-proxy | Node | Implements Service networking rules |
| Container Runtime | Node | Runs containers on Nodes |