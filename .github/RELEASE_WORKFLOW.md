# 🚀 Release Workflow Guide

This project uses automated release note generation when changes are fast-forwarded from `develop` to `main`.

## How It Works

### 1. Fast-Forward Merge (Manual)
When you're ready to release:
1. Create a PR from `develop` → `main`
2. Comment `/fast-forward` on the PR
3. The fast-forward action merges the changes

### 2. Automatic Tagging
Once merged to `main`, the `tag_release.yml` workflow:
- ✅ Automatically creates a timestamp-based tag (e.g., `v20260210`)
- 🏷️ Tags are in format: `vYYYYMMDD`

### 3. Release Notes Generation
When a tag is created, you have **two options**:

#### Option A: Standard Release Notes (Default)
File: `.github/workflows/release_notes.yml`

**Features:**
- Uses GitHub's built-in auto-generated release notes
- Categorizes PRs by labels (configured in `.github/release.yml`)
- Clean, professional format
- Fast and reliable

#### Option B: Enhanced Release Notes
File: `.github/workflows/enhanced_release_notes.yml`

**Features:**
- 🎨 Fancy categorized sections with emojis
- 📊 Commit and PR statistics
- 👥 Contributors acknowledgment
- 🔗 Full changelog links
- More detailed breakdown

### 4. Release Branch Creation
Both workflows automatically create a `release/vXXXXXXXX` branch from the tag for hotfix purposes.

---

## 📋 PR Labeling Guide

To get beautiful categorized release notes, label your PRs:

| Label | Category | Example |
|-------|----------|---------|
| `feature`, `enhancement`, `new` | 🚀 New Features | Add user authentication |
| `bug`, `bugfix`, `fix`, `hotfix` | 🐛 Bug Fixes | Fix login redirect issue |
| `documentation`, `docs` | 📚 Documentation | Update API docs |
| `maintenance`, `chore`, `refactor` | 🔧 Maintenance | Refactor auth module |
| `ui`, `ux`, `design` | 🎨 UI/UX Improvements | Redesign dashboard |
| `performance`, `optimization` | ⚡ Performance | Optimize database queries |
| `security` | 🔒 Security | Fix XSS vulnerability |
| `test`, `testing` | 🧪 Tests | Add integration tests |

---

## 🎯 Best Practices

### For PR Titles
Use clear, descriptive titles:
- ✅ `Add user profile editing feature`
- ✅ `Fix crash when uploading large files`
- ❌ `Fix bug`
- ❌ `Updates`

### For PR Descriptions
Include:
- **What** changed
- **Why** it changed
- **How** to test it

### Labeling Strategy
1. Add labels when creating the PR
2. Use the most specific label that applies
3. One primary label is usually enough
4. The first matching label determines the category

---

## 🔧 Customization

### Change Tag Format
Edit `.github/workflows/tag_release.yml`:
```yaml
TAG_NAME="v$(date -u +'%Y%m%d')"  # Current: v20260210
# Or use semantic versioning:
TAG_NAME="v1.2.3"
```

### Customize Categories
Edit `.github/release.yml` to add/modify categories:
```yaml
changelog:
  categories:
    - title: 🎉 Your Custom Category
      labels:
        - your-label
```

### Switch Between Workflows
**Use Standard (Recommended for most projects):**
```bash
# Keep: .github/workflows/release_notes.yml
# Delete or disable: .github/workflows/enhanced_release_notes.yml
```

**Use Enhanced (For detailed release notes):**
```bash
# Keep: .github/workflows/enhanced_release_notes.yml
# Delete or disable: .github/workflows/release_notes.yml
```

Or disable one by adding to the workflow file:
```yaml
on:
  push:
    tags:
      - "DISABLED"  # This will never trigger
```

---

## 📝 Example Release Notes Output

### Standard Release Notes
```markdown
## What's Changed
### 🚀 New Features
* Add user authentication by @user1 in #42
* Implement real-time notifications by @user2 in #45

### 🐛 Bug Fixes
* Fix login redirect issue by @user1 in #43

**Full Changelog**: v20260201...v20260210
```

### Enhanced Release Notes
```markdown
## What's Changed

This release includes 15 commit(s) and 8 pull request(s).

### 🚀 New Features
- Add user authentication (#42) by @user1
- Implement real-time notifications (#45) by @user2

### 🐛 Bug Fixes
- Fix login redirect issue (#43) by @user1

### 👥 Contributors
Thank you to all contributors: @user1, @user2

**Full Changelog**: https://github.com/org/repo/compare/v20260201...v20260210
```

---

## 🐛 Troubleshooting

### No release notes generated
- Ensure PRs are properly merged (not squashed without PR number in commit message)
- Check that PRs have proper labels
- Verify GitHub App token has correct permissions

### Missing PRs in release notes
- PRs must be merged between the two tags
- Commit messages should reference PR numbers: `(#123)` or `Merge pull request #123`

### Categories not showing
- Verify labels in `.github/release.yml` match PR labels
- Labels are case-insensitive
- Check that PRs have at least one label

---

## 🔐 Required Permissions

GitHub App Token needs:
- `contents: write` - Create releases and tags
- `pull-requests: read` - Read PR information

These are already configured in the workflow files.
