## 0.1.4

- Add getters for common attributes of EPUBs (title, authors and cover).

## 0.1.3

- Update README to show code coverage.

## 0.1.2

- Add equality to models for testing.
- Fix document metadata value when parsed from EPUB2 format.
- Update throwed errors to be more explanatory.
- Add package testing with demo resources.

## 0.1.1

- Updating documentation.

## 0.1.0

- Read EPUB from bytes
- Read EPUB from dart:io file
- List metadata: title, authors, language, etc. (with support for EPUB2)
- List resources: audio, images, text, etc.
- List sections (also commonly named "chapters") in default reading order
- Get section audio (if exists)
- Get text-audio synchronization info for each section
- Get text segment given a time for each section
