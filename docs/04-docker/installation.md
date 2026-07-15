# Docker Installation (Official Repository)

## Server Information

| Item | Value |
|------|-------|
| OS | Debian 13 (Trixie) |
| Docker Version | 29.6.1 |
| Installation Date | 2026-07-15 |

---

# Why Official Docker?

Instead of installing Docker from Debian repositories (`docker.io`), Docker CE was installed from the official Docker repository.

Advantages:

- Latest stable version
- Faster security updates
- Official documentation compatibility
- Production-ready

---

# Installation Steps

## 1. Create Keyrings Directory

```bash
sudo install -m 0755 -d /etc/apt/keyrings
```

---

## 2. Add Docker GPG Key

```bash
curl -fsSL https://download.docker.com/linux/debian/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

---

## 3. Add Docker Repository

```bash
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

---

## 4. Update Packages

```bash
sudo apt update
```

---

## 5. Install Docker

```bash
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

---

## Verify Installation

```bash
docker --version
```

Output:

```
Docker version 29.6.1
```

---

## Notes

Docker was installed using the official Docker repository following production best practices.
