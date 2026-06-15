# FTP vs SFTP vs SCP

## FTP, SFTP, and SCP Differences

### FTP (File Transfer Protocol)
- **Port:** 21
- **Security:** No encryption
- **Purpose:** Transferring files between a client and server.
- **Key Feature:** Sends credentials (username, password) and data in plain text.

### SFTP (SSH File Transfer Protocol)
- **Port:** 22
- **Security:** Encrypted
- **Purpose:** Secure file transfer and file management over a network.
- **Key Feature:** Uses SSH for a secure and authenticated connection.

### SCP (Secure Copy Protocol)
- **Port:** 22
- **Security:** Encrypted
- **Purpose:** Securely copying files between systems.
- **Key Feature:** Simpler than SFTP, primarily for copying files, less for management.

## Pros and Cons of Each

### FTP
#### Pros
- Simple and well-established
- Widely supported by various systems and tools
- Can be lightweight and fast for non-sensitive internal networks

#### Cons
- Insecure and unencrypted
- Passwords and data are vulnerable to eavesdropping
- Generally not recommended for production environments

### SFTP
#### Pros
- Secure and encrypted
- Suitable for production environments
- Supports file management operations like delete, rename, list directories
- Leverages a secure SSH channel

#### Cons
- Can be slightly more resource-intensive than FTP
- Might be overkill for very simple file transfer needs

### SCP
#### Pros
- Very simple for copying files
- Fast and secure
- Based on SSH, thus encrypted

#### Cons
- Limited file management capabilities compared to SFTP
- Not ideal for complex file operations
- Can be less flexible than SFTP in certain scenarios

## Best Scenario for Each

### FTP
- Best for:
  - Test environments
  - Non-sensitive internal networks
  - Situations where security is not a primary concern
  - Not suitable for: Production or sensitive data transfer

### SFTP
- Best for:
  - Production servers
  - Transferring sensitive files
  - When security and file management are required
  - Generally the best all-around choice for secure file transfer

### SCP
- Best for:
  - Quickly copying one or a few files between systems
  - Simple scripting and direct transfers
  - Not suitable for: Complex file management tasks

## Example Commands for Each

### FTP
```bash
ftp example.com
