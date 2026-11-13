import io

p = "lib/l10n/strings.dart"
s = io.open(p, encoding="utf-8").read()
print("bytes:", len(s.encode("utf-8")))
print("has Archived:", "Archived" in s)
i = s.find("'garage.archive'")
print(repr(s[i : i + 90]))
