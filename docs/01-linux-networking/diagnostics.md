# Linux and Networking Lab — Diagnostics Report

## Environment

- OS: Ubuntu Server 22.04.5 LTS
- Container runtime: Docker 29.1.3
- Docker Compose: 2.40.3
- Web server: Nginx
- Compose project: 01-hello-nginx
- Container name: hello-nginx
- Published port: 8080
- Container port: 80
- VM address observed during testing: 192.168.1.168

## Experiment 1: Baseline

### Objective
Verify that Nginx is running and reachable over HTTP.

### Checks
- Docker container status
- Published ports
- Listening sockets using ss
- HTTP response using curl
- Docker systemd service status

### Observed result
- Container status: Up
- Port mapping: 0.0.0.0:8080 -> 80/tcp
- IPv6 port mapping: [::]:8080 -> 80/tcp
- HTTP status: 200 OK
- Docker service: active
- Docker service enabled at boot: enabled

### Conclusion
The web service was reachable locally and returned a successful HTTP response.

## Experiment 2: Incorrect Port Mapping

### Objective
Understand the difference between container health and host port availability.

### Change
Changed the published port from 8080 to 8081 while keeping container port 80.

### Observed result
- Requests to host port 8080 failed with connection refused.
- Requests to host port 8081 initially failed with connection reset.
- Docker reported the container as running with port 8081 published.

### Recovery
Restored the original port mapping and recreated the service.

### Verification
After the service had time to initialize, five consecutive requests to port 8080 returned HTTP 200.

### Conclusion
A running container does not guarantee immediate HTTP availability. Check container status, port mapping, logs, and repeated HTTP requests before concluding that a service is broken.

## Experiment 3: Stop and Recover the Container

### Objective
Observe service failure and recovery.

### Change
Stopped the container using Docker Compose.

### Observed result
- Container status: Exited (0)
- HTTP request: connection refused
- curl HTTP status: 000

### Recovery
Started the container again.

### Verification
An initial request encountered a connection reset. A subsequent request succeeded with HTTP 200.

### Conclusion
HTTP status 000 means curl did not receive an HTTP response. A stopped container can cause connection refusal. During startup, retrying after a short delay can help distinguish temporary unavailability from a persistent failure.

## Experiment 4: Docker Health Check

### Objective
Add a health check to the Compose service.

### Configuration
The health check runs `nginx -t` every 30 seconds, with a 5-second timeout, three retries, and a 10-second start period.

### Observed result
- Health status changed from starting to healthy.
- Docker Compose reported the container as Up (healthy).
- HTTP verification returned 200 OK.

### Limitation
`nginx -t` validates Nginx configuration syntax; it does not independently verify that HTTP requests succeed. A future improvement is an HTTP-based health check.

## Lessons Learned

1. Container state and application availability are different signals.
2. Published host ports must match the intended access path.
3. `curl` status 000 is not an HTTP status code.
4. Docker logs and `docker inspect` help diagnose service behavior.
5. Health checks should test the condition that matters to the application.
6. Recovery should be verified with an actual request.

## Remaining Exercises

- Diagnose a deliberately incorrect DNS record using a lab-only hostname.
- Review the completed experiments and prepare for the next Git/GitHub lab.

## Experiment 5: HTTP-Based Health Check

### Objective
Check actual HTTP availability rather than only validating Nginx configuration syntax.

### Configuration
Updated the Compose health check to run:

`curl -fsS --max-time 3 http://127.0.0.1/`

The check runs every 30 seconds, with a 5-second timeout, three retries, and a 10-second start period.

### Observed result
- Docker reported the container as healthy.
- An HTTP request from inside the VM returned status 200.
- A request from the laptop to `http://192.168.1.168:8080/` returned status 200.
- The health-check definition was confirmed with `docker inspect`.

### Limitation
This check validates HTTP availability inside the container. It does not independently verify access through the host's published port or from another machine.

## Firewall and Network Access

- UFW: inactive.
- firewalld: not installed.
- Docker publishes TCP port 8080 on IPv4 and IPv6.
- The Docker forwarding rules include a default DROP policy on the FORWARD chain, with Docker-managed rules for container traffic.
- DOCKER-USER was empty during inspection.
- From the laptop, TCP connectivity to 192.168.1.168:8080 succeeded.
- HTTP request from the laptop returned HTTP 200.
- SSH connectivity to 192.168.1.168:22 succeeded.
- No firewall rules were changed during this exercise.

## VM Reboot Test

Before reboot:
- Docker service: active and enabled.
- Container restart policy: unless-stopped.
- Container health: healthy.
- HTTP status: 200.

After reboot:
- VM became reachable over SSH at 192.168.1.168.
- Docker service was active and enabled.
- Container hello-nginx was running.
- Container health was healthy.
- Restart policy remained unless-stopped.
- HTTP status from the VM was 200.

Conclusion: Docker and the Nginx container recovered successfully after the VM reboot without manually starting the container.

## Additional Lessons Learned

- A failed non-interactive SSH command using BatchMode=yes does not necessarily indicate an SSH service failure.
- Remote sudo commands may require a terminal to prompt for a password.
- Docker manages its own networking rules, so UFW status alone does not establish whether a published container port is reachable.
- A health check should test the behavior that matters. The current check sends an HTTP request to localhost inside the container.
