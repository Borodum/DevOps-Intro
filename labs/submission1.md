cat > labs/submission1.md << EOF
# Lab 1 Submission
## Task 1: SSH Commit Signature Verification
### Benefits of Commit Signing
Commit signing verifies that commits come from a trusted source and haven't been tampered with. It provides cryptographic proof that the author is who they claim to be. This is crucial for security, audit trails, and maintaining integrity in collaborative projects.
### SSH Key Setup Evidence
```
SSH public key: ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICWs/OR/JmX2jrh53s5LVeGMzj7OnOkiYz6e3TTqOb2Y batraz@dzesov.ru
```
### Git Configuration
- user.signingkey: C:/Users/Borodum/.ssh/id_ed25519.pub
- commit.gpgSign: true
- gpg.format: ssh
- user.email: my@gmail.com
### Signed Commit Verification
Commit hash: fbff5ea shows "Verified" badge on GitHub.
### Importance in DevOps Workflows
Commit signing is important in DevOps because:
1. Ensures code integrity - prevents tampering
2. Provides non-repudiation - authors can't deny their commits
3. Enhances audit trails for compliance
4. Builds trust in automated pipelines and deployments
---
## Task 2: PR Template & Checklist
### PR Template Location
- File exists at: `.github/pull_request_template.md`
- On branch: `main`
### Template Screenshot
[Will add after creating PR]

### How PR Templates Improve Collaboration
PR templates standardize review process, ensure important information isn't missed, and save time by providing a consistent structure for all pull requests.

### Challenges Encountered
- Initial SSH host verification failed
- Commit showed "unverified" initially until SSH key was properly configured on GitHub
---
## Submission Checklist
- [x] Task 1 completed
- [x] Task 2 completed
- [x] PR template created on main branch
- [x] Signed commit made
