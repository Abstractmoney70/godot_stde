```markdown
# Contributing to stde

We love contributions! Here's how to help make stde better.

## 🚀 Quick Start

1. **Fork** the repository
2. **Create a branch** for your feature/fix: `git checkout -b feature/amazing-feature`
3. **Commit your changes**: `git commit -m 'Add amazing feature'`
4. **Push to the branch**: `git push origin feature/amazing-feature`
5. **Open a Pull Request**

## 🎯 Contribution Guidelines

### What We Welcome:
- ✅ **New utility functions** (math, finance, game dev, etc.)
- ✅ **Bug fixes** and edge case handling
- ✅ **Performance optimizations**
- ✅ **Documentation improvements**
- ✅ **Additional test cases**

### What We Avoid:
- ❌ **Breaking changes** to existing function APIs
- ❌ **Game-specific** or **project-specific** utilities
- ❌ **Complex dependencies** or **external libraries**
- ❌ **Overly niche** or **rarely-used** functions

## 🧪 Testing Requirements

**All contributions must include tests!**

```gdscript
# Add your function tests to the test suite
func test_my_new_function() -> int:
    var passed = 0
    test_condition(stde.my_new_function(input) == expected, "Should work correctly")
    return passed
```

Run the test suite before submitting:
```gdscript
# In your Godot project, run:
STDPlusTestSuite.new().run_all_tests()
```

## 📝 Code Standards

- **Use static functions** - no instances or singletons
- **Include doc comments** with `@param` and `@return`
- **Handle edge cases** and null inputs gracefully
- **Follow existing naming conventions** (snake_case)
- **Keep functions focused** and single-purpose

## 🐛 Reporting Bugs

Create an issue with:
1. **Function name** and **inputs** that cause the issue
2. **Expected behavior** vs **actual behavior**
3. **Error messages** or **stack traces**
4. **Godot version** and **platform**

## 💡 Suggesting Features

Open an issue describing:
1. **The problem** you're solving
2. **Proposed function signature**
3. **Use cases** and **examples**
4. **Why it belongs in stde** (generic, reusable)

## 🔄 Release Process

- **Patch versions** (1.0.x) - bug fixes only
- **Minor versions** (1.x.0) - new functions, backward compatible
- **Major versions** (x.0.0) - breaking changes (rare!)

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License.

## 🆘 Need Help?

- **Open a discussion** on GitHub
- **Check existing issues** first

---

**Thank you for helping make stde better!** 🎉
```