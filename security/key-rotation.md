# Firmus Linux Key Rotation Procedure

## GPG Key Overview

The Firmus Linux TCR is signed using a dedicated GPG key:
- **Key ID**: Firmus Linux Signing Key
- **Type**: RSA 4096-bit
- **Expiration**: 2 years from creation
- **Usage**: Signing and certification

## Key Generation

```bash
gpg --full-generate-key
# Kind: RSA and RSA
# Keysize: 4096
# Expiration: 2y
# Real name: Firmus Linux Signing Key
# Email: signing@firmuslinux.org
```

## Export Public Key

```bash
gpg --armor --export "Firmus Linux Signing Key" > firmus.gpg
```

## Key Rotation

1. Generate new key pair 30 days before expiration
2. Sign the new key with the old key
3. Publish new key to `firmus-keyring` package
4. Update `packages/tcr/firmus-keyring/firmus.gpg`
5. Re-sign all TCR packages with new key
6. Update `packages/tcr/firmus-keyring/PKGBUILD`
7. Announce on GitHub Discussions
8. Set expiration of old key to current date

## Revocation

If a key is compromised:
1. Generate revocation certificate
2. Publish to `security/revoked-keys/`
3. Re-sign all packages with new key
4. Push urgent update to `firmus-keyring`
5. Announce immediately
