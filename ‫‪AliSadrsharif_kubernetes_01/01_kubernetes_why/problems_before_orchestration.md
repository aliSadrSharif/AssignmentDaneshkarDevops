# Problems Before Container Orchestration

## 1. Problems of Running Containers Manually Across Multiple Machines

Running applications using only `docker run` across multiple machines creates several operational problems.

### 1.1 Manual Scaling

When application traffic increases, additional containers may be required. With only Docker commands, an administrator has to manually create and configure additional containers on different machines.

### 1.2 Handling Container Crashes

If a container crashes, an administrator may need to detect the failure and manually restart or replace the container. This becomes difficult when many containers are running across multiple machines.

### 1.3 Load Balancing

When multiple application containers are running, incoming traffic needs to be distributed between them. Managing this manually becomes complicated as the number of containers and machines increases.

### 1.4 Downtime During Updates

A manual deployment may require stopping the existing containers before starting the new version. If all old containers are stopped first, the application can become temporarily unavailable.

### 1.5 Difficult Multi-Machine Management

Managing containers individually on multiple servers requires many manual commands. Maintaining consistent configurations and tracking the state of all containers becomes increasingly difficult as the infrastructure grows.

---

## 2. What Does Self-Healing Mean in Kubernetes?

Self-healing means that Kubernetes continuously works to maintain the desired state of an application and automatically responds to certain failures.

### Practical Example

Suppose a Kubernetes Deployment requires 3 replicas of an application.

If one Pod crashes, only 2 replicas remain available. Kubernetes detects that the current state does not match the desired state and creates a replacement Pod.

Therefore, the desired number of replicas can be restored without requiring an administrator to manually recreate the failed Pod.

---

## 3. Rolling Update vs Manual Deployment

### Manual Deployment

In a manual deployment, the existing application instances may be stopped first and then the new version is started.

For example:

```text
Stop old containers
        ↓
Application temporarily unavailable
        ↓
Start new containers
        ↓
New version becomes available
```

This approach can cause downtime and creates additional risk if the new version fails.

### Rolling Update

A rolling update gradually replaces old application instances with new ones.

For example:

```text
Initial:
3 old instances

Update:
1 old → 1 new
2 old → 2 new
3 old → 3 new

Final:
3 new instances
```

The old instances are replaced gradually rather than being stopped all at once. This helps keep the application available during the deployment.

---

## 4. Why Docker Alone Is Not Enough for Large-Scale Production

Docker provides the basic capabilities required to build and run containers. However, managing a large number of containers across multiple machines requires additional orchestration capabilities.

Large production environments commonly require:

- Automatic scaling
- Self-healing
- Load balancing
- Service discovery
- Rolling updates
- Scheduling workloads across machines
- Centralized management of containers

Using individual `docker run` commands becomes difficult and error-prone when the number of containers and machines grows.

A container orchestrator such as Kubernetes provides mechanisms for managing these workloads and maintaining the desired state of applications across a cluster.