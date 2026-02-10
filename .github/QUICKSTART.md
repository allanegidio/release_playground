# 🎯 Quick Start: Choose Your Release Notes Style

You have **two workflows** available. Choose one:

## Option 1: Standard Release Notes ⭐ RECOMMENDED
**File:** `.github/workflows/release_notes.yml`

### ✅ Use when:
- You want clean, professional release notes
- You prefer GitHub's native formatting
- You want minimal maintenance
- Your team consistently labels PRs

### 📋 Output Example:
```markdown
## What's Changed
### 🚀 New Features
* Add user authentication by @user1 in #42
* Implement notifications by @user2 in #45
### 🐛 Bug Fixes
* Fix login redirect by @user1 in #43

**Full Changelog**: v20260201...v20260210
```

### 🚀 To Use:
1. ✅ Already active! (This is the default)
2. Label your PRs properly
3. Merge to main using `/fast-forward`
4. Release notes auto-generate on tag creation

---

## Option 2: Enhanced Release Notes 🎨
**File:** `.github/workflows/enhanced_release_notes.yml`

### ✅ Use when:
- You want fancy, detailed release notes
- You want contributor acknowledgments
- You want commit statistics
- You want more emoji categorization

### 📋 Output Example:
```markdown
## What's Changed

This release includes 15 commit(s) and 8 pull request(s).

### 🚀 New Features
- Add user authentication (#42) by @user1
- Implement notifications (#45) by @user2

### 🐛 Bug Fixes
- Fix login redirect (#43) by @user1

### 👥 Contributors
Thank you: @user1, @user2

**Full Changelog**: https://github.com/org/repo/compare/v20260201...v20260210
```

### 🚀 To Use:
**Switch to enhanced:**
```bash
# Disable standard
mv .github/workflows/release_notes.yml .github/workflows/release_notes.yml.disabled

# Enable enhanced (already created)
# File already exists: .github/workflows/enhanced_release_notes.yml
```

---

## 🏃 Quick Decision Guide

| Feature | Standard | Enhanced |
|---------|----------|----------|
| Auto-categorization | ✅ | ✅ |
| Emoji support | ✅ | ✅ |
| GitHub native | ✅ | ❌ |
| Commit stats | ❌ | ✅ |
| Contributors list | ❌ | ✅ |
| Maintenance | Low | Medium |
| Speed | Fast | Slightly slower |

---

## 🎬 Getting Started (3 steps)

### 1. Label Your PRs
Add labels when creating PRs:
- `feature` = 🚀 New Features
- `bug` or `hotfix` or `fix` = 🐛 Bug Fixes  
- `docs` = 📚 Documentation
- `chore` = 🔧 Maintenance

### 2. Merge to Main
On your develop → main PR, comment:
```
/fast-forward
```

### 3. Done! 🎉
- Tag created automatically (e.g., `v20260210`)
- Release notes generated automatically
- Release branch created (`release/v20260210`)

---

## 🔄 Switching Between Workflows

### Keep Both (Both will run - creates duplicate releases!)
```bash
# Both files active = 2 releases created
# ⚠️ NOT RECOMMENDED
```

### Use Standard (Recommended)
```bash
# Disable enhanced
mv .github/workflows/enhanced_release_notes.yml \
   .github/workflows/enhanced_release_notes.yml.disabled
```

### Use Enhanced
```bash
# Disable standard
mv .github/workflows/release_notes.yml \
   .github/workflows/release_notes.yml.disabled
```

---

## 📚 More Information

Read the full guide: [RELEASE_WORKFLOW.md](RELEASE_WORKFLOW.md)

---

## ❓ FAQ

**Q: Which one should I use?**
A: Start with **Standard** (it's already active). Switch to Enhanced if you want more details.

**Q: Can I customize the categories?**
A: Yes! Edit `.github/release.yml` to add/modify categories.

**Q: Do I need a CHANGELOG.md file?**
A: No! Release notes are auto-generated from your PRs.

**Q: What if I forget to label a PR?**
A: It will appear in "Other Changes" category.

**Q: Can I edit release notes after creation?**
A: Yes! Edit them directly on GitHub's release page.
