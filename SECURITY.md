# Security Policy

## Supported Versions

We release security updates for the following versions of FoodEx:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

The FoodEx team takes security bugs seriously. We appreciate your efforts to responsibly disclose your findings, and will make every effort to acknowledge your contributions.

### How to Report a Security Vulnerability?

**Please do NOT report security vulnerabilities through public GitHub issues.**

Instead, please report them via email to [security@foodex.ma](mailto:security@foodex.ma).

You should receive a response within 48 hours. If for some reason you do not, please follow up via email to ensure we received your original message.

### What to Include in Your Report

Please include the following information in your report:

- Type of issue (e.g., buffer overflow, SQL injection, cross-site scripting, etc.)
- Full paths of source file(s) related to the manifestation of the issue
- The location of the affected source code (tag/branch/commit or direct URL)
- Any special configuration required to reproduce the issue
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the issue, including how an attacker might exploit it

This information will help us triage your report more quickly.

### What to Expect

After you submit a report, here's what happens:

1. **Acknowledgment**: We'll acknowledge receipt of your vulnerability report within 48 hours.

2. **Initial Assessment**: Our security team will assess the reported vulnerability and determine its severity and impact. We'll provide an initial assessment within 5 business days.

3. **Investigation**: We'll investigate the vulnerability in depth, working to:
   - Understand the full scope of the issue
   - Identify all affected versions
   - Develop a fix or mitigation

4. **Fix Development**: We'll develop a fix and test it thoroughly. Timeline depends on severity:
   - **Critical**: 1-2 weeks
   - **High**: 2-4 weeks
   - **Medium**: 4-8 weeks
   - **Low**: 8-12 weeks

5. **Disclosure**: Once a fix is ready:
   - We'll release the fix in a new version
   - We'll publish a security advisory
   - We'll credit you in the advisory (unless you prefer to remain anonymous)

## Security Best Practices for Users

### For End Users

1. **Keep Your App Updated**: Always use the latest version of FoodEx
2. **Strong Passwords**: Use strong, unique passwords for your account
3. **Enable Two-Factor Authentication**: If available, enable 2FA
4. **Be Cautious with Links**: Don't click on suspicious links in notifications
5. **Review Permissions**: Periodically review app permissions
6. **Use Secure Networks**: Avoid using public Wi-Fi for sensitive transactions
7. **Report Suspicious Activity**: Report any suspicious activity immediately

### For Developers

1. **Dependency Updates**: Keep all dependencies up to date
2. **Secure Coding Practices**: Follow secure coding guidelines
3. **Code Reviews**: Conduct thorough code reviews
4. **Testing**: Include security testing in your test suite
5. **Secrets Management**: Never commit secrets or API keys
6. **Input Validation**: Always validate and sanitize user input
7. **Authentication**: Use strong authentication mechanisms
8. **Authorization**: Implement proper authorization checks

## Known Security Considerations

### Current Security Measures

- **HTTPS Only**: All API communications use HTTPS
- **JWT Authentication**: Secure token-based authentication
- **Input Validation**: Server-side input validation and sanitization
- **SQL Injection Protection**: Parameterized queries throughout
- **XSS Protection**: Output encoding and Content Security Policy
- **CSRF Protection**: CSRF tokens for state-changing operations
- **Rate Limiting**: API rate limiting to prevent abuse
- **Password Hashing**: Bcrypt for password storage
- **Secure Sessions**: HTTP-only, secure cookies
- **Data Encryption**: Sensitive data encrypted at rest

### Planned Security Enhancements

- [ ] SSL Certificate Pinning
- [ ] Biometric Authentication
- [ ] Advanced Fraud Detection
- [ ] Penetration Testing
- [ ] Security Audit by Third Party
- [ ] Bug Bounty Program

## Security Advisories

Security advisories will be published on:

- [GitHub Security Advisories](https://github.com/MOUBI9A/foodex/security/advisories)
- [FoodEx Security Page](https://foodex.ma/security)
- Email notifications to registered users (for critical issues)

## Security Response Team

Our security response team consists of:

- Lead Security Engineer
- Backend Team Lead
- Mobile App Lead
- Infrastructure Lead

## Contact

For security-related questions or concerns:

- Email: [security@foodex.ma](mailto:security@foodex.ma)
- PGP Key: Available at [https://foodex.ma/pgp-key](https://foodex.ma/pgp-key)

## Bug Bounty Program

**Coming Soon**: We're working on establishing a bug bounty program to reward security researchers for responsibly disclosing vulnerabilities. Stay tuned for updates!

## Compliance

FoodEx is committed to maintaining compliance with:

- GDPR (General Data Protection Regulation)
- PCI DSS (Payment Card Industry Data Security Standard)
- OWASP Top 10 Security Risks
- Mobile App Security Verification Standard (MASVS)

## Third-Party Security

We use industry-standard third-party services for:

- Payment Processing: Stripe (PCI DSS compliant)
- Cloud Infrastructure: AWS/Google Cloud (SOC 2 certified)
- Authentication: OAuth 2.0 providers
- Monitoring: Sentry, Firebase

All third-party integrations are regularly reviewed for security.

## Data Privacy

For information about how we handle your data, please see our [Privacy Policy](https://foodex.ma/privacy).

## Updates to This Policy

We may update this security policy from time to time. We will notify you of any changes by posting the new policy on this page and updating the "Last Updated" date.

**Last Updated**: October 24, 2025

---

Thank you for helping keep FoodEx and our users safe! 🔒
