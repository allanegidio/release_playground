# 🚀 Automated Release Notes

This project automatically generates release notes from PR labels when changes are merged to main.

## How It Works

```
1. Create PR: develop → main
2. Comment: /fast-forward on PR
3. Changes merge to main
4. Tag created automatically (v20260210-120000)
5. Release notes generated with categorized changes
6. Release branch created (release/v20260210-120000)
```

**Total time:** ~1-2 minutes (fully automated!)

---

## 📋 PR Labels

Label your PRs to categorize changes in release notes:

| Label | Category in Release Notes |
|-------|---------------------------|
| `feature`, `enhancement`, `new` | 🚀 New Features |
| `bug`, `bugfix`, `fix`, `hotfix` | 🐛 Bug Fixes |
| `docs`, `documentation` | 📚 Documentation |
| `chore`, `maintenance`, `refactor` | 🔧 Maintenance |
| `ui`, `ux`, `design` | 🎨 UI/UX Improvements |
| `performance`, `optimization` | ⚡ Performance |
| `security` | 🔒 Security |
| `test`, `testing` | 🧪 Tests |
| _no label_ | 📦 Other Changes |

---

## 🎯 Quick Start

### 1. Label Your PR
When creating a PR, add one label:
- `feature` for new features
- `bug` or `hotfix` for bug fixes  
- `docs` for documentation changes
- `chore` for maintenance

### 2. Merge to Main
On your `develop` → `main` PR, comment:
```
/fast-forward
```

### 3. Done! 🎉
Release notes are automatically generated and published!

---

## 📝 Release Notes Example

```markdown
## What's Changed

### 🚀 New Features
* Add user authentication by @user1 in #42
* Implement notifications by @user2 in #45

### 🐛 Bug Fixes
* Fix login redirect issue by @user1 in #43
* Resolve database connection timeout by @user3 in #44

### 📚 Documentation
* Update API documentation by @user2 in #46

**Full Changelog**: v20260201-120000...v20260210-120000
```

---

## 🔧 Customization

### Add Custom Categories

Edit [`.github/release.yml`](./release.yml):

```yaml
changelog:
  categories:
    - title: 🎉 Your Custom Category
      labels:
        - your-custom-label
```

### Change Tag Format

Edit [`.github/workflows/tag_release.yml`](./workflows/tag_release.yml):

```yaml
# Current: v20260210-120000 (timestamp)
TAG_NAME="v$(date -u +'%Y%m%d-%H%M%S')"

# Or use semantic versioning:
TAG_NAME="v1.2.3"
```

---

## 📁 Workflow Files

| File | Purpose |
|------|---------|
| [`fast_forward.yml`](./workflows/fast_forward.yml) | Merges develop → main via `/fast-forward` comment |
| [`tag_release.yml`](./workflows/tag_release.yml) | Creates timestamp tags automatically |
| [`release_notes.yml`](./workflows/release_notes.yml) | Generates categorized release notes from PRs |
| [`release.yml`](./release.yml) | Configures label-to-category mapping |
| [`PULL_REQUEST_TEMPLATE.md`](./PULL_REQUEST_TEMPLATE.md) | PR template with checklist |

---

## 🔐 Required Secrets

Set these in your repository settings:

```yaml
APP_ID: Your GitHub App ID
APP_PRIVATE_KEY: Your GitHub App Private Key
```

GitHub App permissions needed:
- `contents: write` - Create releases, tags, branches
- `pull-requests: read` - Read PR information

---

## ❓ FAQ

**Q: What if I forget to label a PR?**  
A: It will appear in "Other Changes" category.

**Q: Can I use multiple labels?**  
A: Yes, but only the first matching label determines the category.

**Q: Can I edit release notes after creation?**  
A: Yes! Edit them directly on the GitHub Releases page.

**Q: Do I need a CHANGELOG.md file?**  
A: No! Release notes are auto-generated from PRs.

**Q: How do I test the workflow?**  
A: Create a test PR with labels, merge it, and check the Releases page!

---

## 🎓 Best Practices

1. **Label PRs immediately** when creating them
2. **Write clear PR titles** - they appear in release notes
3. **Review labels before merging** to ensure proper categorization
4. **Use descriptive PR descriptions** for better context
5. **Keep PRs focused** - one feature/fix per PR when possible

---

## 🐛 Troubleshooting

### No release created?
1. Check if tag was created in repository
2. Review workflow logs in Actions tab
3. Verify GitHub App token permissions

### PR not appearing in release notes?
1. Ensure PR was merged (not squashed without PR number)
2. Check that commit message includes PR number `(#123)`
3. Verify tag encompasses the merged PR

### Wrong category?
1. Check PR labels match those in `release.yml`
2. Labels are case-insensitive
3. First matching label wins

---

## 🎉 That's It!

Your automated release notes are ready to use. Just label your PRs and merge with `/fast-forward` - everything else is automatic!
